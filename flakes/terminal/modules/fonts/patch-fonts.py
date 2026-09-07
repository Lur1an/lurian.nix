#!/usr/bin/env python3

import argparse
import os
import sys

import fontforge
import psMat


def parse_args():
    parser = argparse.ArgumentParser(
        description="Inject SVG glyphs into a font without replacing existing mappings."
    )
    parser.add_argument("input_font")
    parser.add_argument("output_font")
    parser.add_argument(
        "glyphs",
        nargs="+",
        metavar="GLYPH",
        help="Repeated triples: glyph-name codepoint svg-path",
    )
    args = parser.parse_args()
    if len(args.glyphs) % 3 != 0:
        parser.error("glyph definitions must be triples: glyph-name codepoint svg-path")
    return args


def monospace_advance(font):
    ascii_widths = {
        glyph.width
        for glyph in font.glyphs()
        if 0x20 <= glyph.unicode <= 0x7E
    }
    if len(ascii_widths) == 1:
        return ascii_widths.pop()
    return font.em


def add_glyph(font, name, codepoint, svg_path):
    for existing in font.glyphs():
        if existing.unicode == codepoint:
            raise RuntimeError(
                f"{font.path}: U+{codepoint:04X} is already mapped to {existing.glyphname}"
            )

    glyph = font.createChar(codepoint, name)
    glyph.importOutlines(svg_path)
    glyph.removeOverlap()
    glyph.correctDirection()

    xmin, ymin, xmax, ymax = glyph.boundingBox()
    width = xmax - xmin
    height = ymax - ymin
    if width <= 0 or height <= 0:
        raise RuntimeError(f"{svg_path}: imported outline is empty")

    scale = font.em / max(width, height)
    glyph.transform(psMat.scale(scale))

    xmin, ymin, xmax, ymax = glyph.boundingBox()
    advance = monospace_advance(font)
    glyph.transform(
        psMat.translate(
            (advance - (xmax - xmin)) / 2 - xmin,
            -font.descent - ymin,
        )
    )
    glyph.width = advance


def main():
    args = parse_args()
    input_extension = os.path.splitext(args.input_font)[1].lower()
    output_extension = os.path.splitext(args.output_font)[1].lower()
    if input_extension not in {".otf", ".ttf"} or output_extension != input_extension:
        raise RuntimeError("input and output must use the same .otf or .ttf extension")

    font = fontforge.open(args.input_font)
    try:
        for offset in range(0, len(args.glyphs), 3):
            name, raw_codepoint, svg_path = args.glyphs[offset : offset + 3]
            add_glyph(font, name, int(raw_codepoint, 0), svg_path)
        os.makedirs(os.path.dirname(os.path.abspath(args.output_font)), exist_ok=True)
        font.generate(args.output_font)
    finally:
        font.close()


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"patch-fonts.py: {error}", file=sys.stderr)
        raise SystemExit(1)
