
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#f1dfdc',
  black = '#1a1110',
  darker_black = lighten('#1a1110', -3),
  black2 = lighten('#1a1110', 6),
  one_bg = lighten('#1a1110', 10),
  one_bg2 = lighten('#1a1110', 16),
  one_bg3 = lighten('#1a1110', 22),

  grey = '#534341',
  grey_fg = lighten('#534341', -10),
  grey_fg2 = lighten('#534341', -20),
  light_grey = '#a08c89',

  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#dec48c',

  line = '#a08c89',

  green = '#e7bdb6',
  vibrant_green = lighten('#e7bdb6', 10),

  blue = '#ffb4a8',
  nord_blue = lighten('#ffb4a8', 10),

  yellow = lighten('#dec48c', 10),
  sun = lighten('#dec48c', 20),

  purple = '#dec48c',
  dark_purple = lighten('#dec48c', -10),

  teal = '#5d3f3b',
  orange = '#ffb4ab',
  cyan = '#e7bdb6',

  statusline_bg = lighten('#1a1110', 6),
  pmenu_bg = '#534341',
  folder_bg = lighten('#ffb4a8', 0),
}

M.base_16 = {
  base00 = '#1a1110',                   -- Default Background
  base01 = lighten('#534341', 0),       -- Lighter Background (status bars)
  base02 = '#5d3f3b',              -- Selection Background
  base03 = lighten('#a08c89', 0),           -- Comments, Invisibles, Line Highlighting
  base04 = lighten('#d8c2be', 0),  -- Dark Foreground (status bars)
  base05 = '#f1dfdc',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('#f1dfdc', 0),   -- Light Foreground (Not often used)
  base07 = '#1a1110',               -- Light Background (Not often used)
  base08 = lighten('#ffb4ab', -10),                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#dec48c',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#ffb4a8',                     -- Classes, Markup Bold, Search Text Background
  base0B = '#fbdfa6',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#564419',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = lighten('#73342b', 15),                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '#ffdad4',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#f1dfdc',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
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