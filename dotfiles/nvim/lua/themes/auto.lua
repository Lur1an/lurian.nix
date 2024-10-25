
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#dde4e3',
  black = '#0e1514',
  darker_black = lighten('#0e1514', -3),
  black2 = lighten('#0e1514', 6),
  one_bg = lighten('#0e1514', 10),
  one_bg2 = lighten('#0e1514', 16),
  one_bg3 = lighten('#0e1514', 22),

  grey = '#3f4948',
  grey_fg = lighten('#3f4948', -10),
  grey_fg2 = lighten('#3f4948', -20),
  light_grey = '#889392',

  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#b2c8e8',

  line = '#889392',

  green = '#b0cccb',
  vibrant_green = lighten('#b0cccb', 10),

  blue = '#80d5d3',
  nord_blue = lighten('#80d5d3', 10),

  yellow = lighten('#b2c8e8', 10),
  sun = lighten('#b2c8e8', 20),

  purple = '#b2c8e8',
  dark_purple = lighten('#b2c8e8', -10),

  teal = '#324b4b',
  orange = '#ffb4ab',
  cyan = '#b0cccb',

  statusline_bg = lighten('#0e1514', 6),
  pmenu_bg = '#3f4948',
  folder_bg = '#00504f',
}

M.base_16 = {
  base00 = '#0e1514',                   -- Default Background
  base01 = lighten('#3f4948', 0),       -- Lighter Background (status bars)
  base02 = '#324b4b',              -- Selection Background
  base03 = lighten('#889392', 0),           -- Comments, Invisibles, Line Highlighting
  base04 = lighten('#bec9c8', 0),  -- Dark Foreground (status bars)
  base05 = '#dde4e3',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('#dde4e3', 0),   -- Light Foreground (Not often used)
  base07 = '#0e1514',               -- Light Background (Not often used)
  base08 = lighten('#ffb4ab', -10),                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#b2c8e8',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#80d5d3',                     -- Classes, Markup Bold, Search Text Background
  base0B = '#d2e4ff',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#334863',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = lighten('#00504f', 15),                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '#9cf1ef',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#dde4e3',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

M.type = "dark"  -- or "light" depending on your theme

M.polish_hl = {
  defaults = {
    Comment = {
      italic = true,
      fg = M.base_16.base03,
    },
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
  }
}

return M