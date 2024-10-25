
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#e1e4d9',
  black = '#11140e',
  darker_black = lighten('#11140e', -3),
  black2 = lighten('#11140e', 6),
  one_bg = lighten('#11140e', 10),
  one_bg2 = lighten('#11140e', 16),
  one_bg3 = lighten('#11140e', 22),

  grey = '#43483e',
  grey_fg = lighten('#43483e', -10),
  grey_fg2 = lighten('#43483e', -20),
  light_grey = '#8e9286',

  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#a0cfcf',

  line = '#8e9286',

  green = '#bdcbaf',
  vibrant_green = lighten('#bdcbaf', 10),

  blue = '#abd28f',
  nord_blue = lighten('#abd28f', 10),

  yellow = lighten('#a0cfcf', 10),
  sun = lighten('#a0cfcf', 20),

  purple = '#a0cfcf',
  dark_purple = lighten('#a0cfcf', -10),

  teal = '#3e4a35',
  orange = '#ffb4ab',
  cyan = '#bdcbaf',

  statusline_bg = lighten('#11140e', 6),
  pmenu_bg = '#43483e',
  folder_bg = lighten('#abd28f', 0),
}

M.base_16 = {
  base00 = '#11140e',                   -- Default Background
  base01 = lighten('#43483e', 0),       -- Lighter Background (status bars)
  base02 = '#bdcbaf',              -- Selection Background
  base03 = lighten('#8e9286', 0),           -- Comments, Invisibles, Line Highlighting
  base04 = lighten('#c4c8bb', 0),  -- Dark Foreground (status bars)
  base05 = '#e1e4d9',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('#e1e4d9', 0),   -- Light Foreground (Not often used)
  base07 = '#11140e',               -- Light Background (Not often used)
  base08 = lighten('#ffb4ab', -10),                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#a0cfcf',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#abd28f',                     -- Classes, Markup Bold, Search Text Background
  base0B = '#bbebeb',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#abd28f',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = lighten('#2f4f1b', 20),                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '#c7eea9',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#e1e4d9',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

M.type = "dark"  -- or "light" depending on your theme

M.polish_hl = {
  defaults = {
    Comment = {
      italic = true,
      fg = M.base_16.base03,
    },
  },
  Syntax = {
    String = {
      fg = '#bbebeb'
    }
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = '#bbebeb'
    },
  }
}

return M