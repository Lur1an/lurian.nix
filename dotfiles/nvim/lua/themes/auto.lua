
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#e7e0e8',
  darker_black = lighten('#141218', -3),
  black = '#141218',
  black2 = lighten('#141218', 6),
  one_bg = lighten('#141218', 10),
  grey = lighten('#141218', 40),
  light_grey = '#49454e',
  red = '#ffb4ab',
  baby_pink = '#93000a',
  pink = '#67558e',
  line = '#49454e',
  green = '#d1bcfd',
  vibrant_green = '#4e3d75',
  nord_blue = '#f0b8c6',
  blue = '#f0b8c6',
  yellow = '#ccc2db',
  sun = lighten('#ccc2db', 6),
  purple = '#67558e',
  dark_purple = '#67558e',
  teal = '#f0b8c6',
  orange = '#ffb4ab',
  cyan = '#4a4358',
  pmenu_bg = '#49454e',
  folder_bg = '#f0b8c6',
}

M.base_30.statusline_bg = M.base_30.black2
M.base_30.lightbg = M.base_30.one_bg
M.base_30.one_bg2 = lighten(M.base_30.one_bg, 6)
M.base_30.one_bg3 = lighten(M.base_30.one_bg2, 6)
M.base_30.grey_fg = lighten(M.base_30.grey, 10)
M.base_30.grey_fg2 = lighten(M.base_30.grey, 5)

M.base_16 = {
  base00 = '#141218',
  base01 = '#141218',
  base02 = '#49454e',
  base03 = '#49454e',
  base04 = '#e7e0e8',
  base05 = '#e7e0e8',
  base06 = '#cbc4cf',
  base07 = '#cbc4cf',
  base08 = '#ffb4ab',
  base09 = '#d1bcfd',
  base0A = '#ccc2db',
  base0B = '#f0b8c6',
  base0C = '#4e3d75',
  base0D = '#4a4358',
  base0E = '#ffb4ab',
  base0F = '#cbc4cf',
}

M.type = "dark"

M.polish_hl = {
  Operator = {
    fg = M.base_30.nord_blue,
  },

  ["@operator"] = {
    fg = M.base_30.nord_blue,
  },
}

return M
    