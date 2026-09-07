{
  stdenv,
  fontforge,
  python3Packages,
}:
stdenv.mkDerivation {
  name = "lurianFonts";
  src = ./files;

  nativeBuildInputs = [fontforge python3Packages.fonttools];

  phases = ["installPhase"];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts"
    cp -r "$src"/. "$out/share/fonts"
    chmod -R u+w "$out/share/fonts"

    while IFS= read -r -d "" font; do
      relativePath="''${font#"$src"/}"
      output="$out/share/fonts/$relativePath"
      patched="''${output%.*}.patched.''${output##*.}"
      restored="''${output%.*}.restored.''${output##*.}"
      nameTable="$output.name.ttx"

      # U+E00B is the first slot free in every bundled source font.
      fontforge -lang=py -script ${./patch-fonts.py} \
        "$font" "$patched" \
        surrealdb 0xE00B ${./glyphs/surrealdb.svg}
      ttx -q -t name -o "$nameTable" "$font"
      ttx -q -m "$patched" -o "$restored" "$nameTable"
      mv "$restored" "$output"
      rm "$patched" "$nameTable"
    done < <(find "$src" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -print0)

    runHook postInstall
  '';
}
