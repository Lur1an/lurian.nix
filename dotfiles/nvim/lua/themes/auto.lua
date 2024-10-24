
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#dfe3e7',
  black = '#0f1417',
  darker_black = lighten('#0f1417', -3),
  black2 = lighten('#0f1417', 6),
  one_bg = lighten('#0f1417', 10),
  one_bg2 = lighten('#0f1417', 16),
  one_bg3 = lighten('#0f1417', 22),

  grey = '#40484c',
  grey_fg = lighten('#40484c', -10),
  grey_fg2 = lighten('#40484c', -20),
  light_grey = '#8a9297',

  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#c6c2ea',

  line = '#8a9297',

  green = '#b4cad6',
  vibrant_green = lighten('#b4cad6', 10),

  blue = '#8bd0ef',
  nord_blue = lighten('#8bd0ef', 10),

  yellow = lighten('#c6c2ea', 10),
  sun = lighten('#c6c2ea', 20),

  purple = '#c6c2ea',
  dark_purple = lighten('#c6c2ea', -10),

  teal = '#354a53',
  orange = '#ffb4ab',
  cyan = '#b4cad6',

  statusline_bg = lighten('#0f1417', 6),
  pmenu_bg = '#40484c',
  folder_bg = '#004d64',
}

M.base_16 = {
  base00 = '#0f1417',                   -- Default Background
  base01 = lighten('#0f1417', 5),       -- Lighter Background (status bars)
  base02 = '#40484c',              -- Selection Background
  base03 = '#8a9297',                      -- Comments, Invisibles, Line Highlighting
  base04 = lighten('#dfe3e7', -20),  -- Dark Foreground (status bars)
  base05 = '#dfe3e7',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('#dfe3e7', 20),   -- Light Foreground (Not often used)
  base07 = '#353a3d',               -- Light Background (Not often used)
  base08 = '#ffb4ab',                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#b4cad6',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#c6c2ea',                     -- Classes, Markup Bold, Search Text Background
  base0B = '#8bd0ef',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#b4cad6',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = '#8bd0ef',                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '#c6c2ea',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#ffb4ab',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

M.type = "dark"  -- or "light" depending on your theme

M.polish_hl = {
  Operator = {
    fg = M.base_30.nord_blue,
  },

  ["@operator"] = {
    fg = M.base_30.nord_blue,
  },
}

return M
    