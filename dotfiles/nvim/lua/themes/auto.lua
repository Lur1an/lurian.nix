
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#dee3e6',
  black = '#0f1416',
  darker_black = lighten('#0f1416', -3),
  black2 = lighten('#0f1416', 6),
  one_bg = lighten('#0f1416', 10),
  one_bg2 = lighten('#0f1416', 16),
  one_bg3 = lighten('#0f1416', 22),

  grey = '#40484b',
  grey_fg = lighten('#40484b', -10),
  grey_fg2 = lighten('#40484b', -20),
  light_grey = '#899296',

  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#c1c4eb',

  line = '#899296',

  green = '#b3cad4',
  vibrant_green = lighten('#b3cad4', 10),

  blue = '#86d1ea',
  nord_blue = lighten('#86d1ea', 10),

  yellow = lighten('#c1c4eb', 10),
  sun = lighten('#c1c4eb', 20),

  purple = '#c1c4eb',
  dark_purple = lighten('#c1c4eb', -10),

  teal = '#344a52',
  orange = '#ffb4ab',
  cyan = '#b3cad4',

  statusline_bg = lighten('#0f1416', 6),
  pmenu_bg = '#40484b',
  folder_bg = '#004e5f',
}

M.base_16 = {
  base00 = '#0f1416',                   -- Default Background
  base01 = lighten('#0f1416', 5),       -- Lighter Background (status bars)
  base02 = '#40484b',              -- Selection Background
  base03 = '#899296',                      -- Comments, Invisibles, Line Highlighting
  base04 = lighten('#dee3e6', -20),  -- Dark Foreground (status bars)
  base05 = '#dee3e6',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('#dee3e6', 20),   -- Light Foreground (Not often used)
  base07 = '#343a3c',               -- Light Background (Not often used)
  base08 = '#ffb4ab',                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#b3cad4',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#c1c4eb',                     -- Classes, Markup Bold, Search Text Background
  base0B = '#86d1ea',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#b3cad4',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = '#86d1ea',                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '#c1c4eb',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
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
    