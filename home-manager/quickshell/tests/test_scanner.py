import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from urllib.parse import unquote, urlparse

spec = importlib.util.spec_from_file_location(
    "scanner", Path(__file__).parents[1] / "scripts/scan-wallpapers.py"
)
scanner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scanner)


class ScannerTests(unittest.TestCase):
    def test_symlinked_roots_deduplication_and_media_types(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "library"
            root.mkdir()
            (root / "nested").mkdir()
            for name in ["still.JPG", "animated.GIF", "nested/video.mp4", "ignore.txt"]:
                (root / name).touch()
            link = Path(directory) / "wallpapers"
            link.symlink_to(root, target_is_directory=True)
            (root / "cycle").symlink_to(root, target_is_directory=True)
            (root / "alias.gif").symlink_to(root / "animated.GIF")
            result = scanner.scan([str(link), str(root), str(root / "nested")])
            self.assertEqual(len(result["entries"]), 3)
            self.assertEqual(
                {entry["kind"] for entry in result["entries"]},
                {"image", "gif", "video"},
            )
            self.assertEqual(result["warnings"], [])

    def test_filenames_survive_json_and_url_encoding(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "雪 'quoted' #100%\nwallpaper.gif"
            path.touch()
            data = json.loads(json.dumps(scanner.scan([directory])))
            entry = data["entries"][0]
            self.assertEqual(entry["name"], path.name)
            self.assertEqual(entry["path"], str(path))
            self.assertEqual(unquote(urlparse(entry["url"]).path), str(path))

    def test_unavailable_root_does_not_hide_available_media(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "good.webp").touch()
            (root / "broken.jpg").symlink_to(root / "missing-target")
            result = scanner.scan([str(root / "missing"), directory])
            self.assertEqual(
                [entry["name"] for entry in result["entries"]], ["good.webp"]
            )
            self.assertEqual(len(result["warnings"]), 2)


if __name__ == "__main__":
    unittest.main()
