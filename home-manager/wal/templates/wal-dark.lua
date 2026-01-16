-- NvChad base46 theme template for pywal
-- Designed to work with any WAL palette including low-saturation/monochromatic ones
-- Uses lighten() extensively to ensure readable contrast

local M = {{}}

local lighten = require("base46.colors").change_hex_lightness

-- ============================================================================
-- BASE_30: UI Colors
-- ============================================================================
M.base_30 = {{
  -- Foreground
  white = "{color7}",
  
  -- Background gradient
  darker_black = lighten("{color0}", -3),
  black = "{color0}",
  black2 = lighten("{color0}", 6),
  one_bg = lighten("{color0}", 10),
  one_bg2 = lighten("{color0}", 16),
  one_bg3 = lighten("{color0}", 22),
  
  -- Grey gradient
  grey = lighten("{color0}", 35),
  grey_fg = lighten("{color0}", 45),
  grey_fg2 = lighten("{color0}", 40),
  light_grey = lighten("{color8}", 20),
  
  -- Line/separator
  line = lighten("{color0}", 12),
  
  -- Accent colors - HIGH CONTRAST (matching bearded-arc 70-80% lightness)
  red = lighten("{color5}", 40),
  baby_pink = lighten("{color5}", 50),
  pink = lighten("{color5}", 45),
  
  green = lighten("{color1}", 55),
  vibrant_green = lighten("{color1}", 65),
  
  blue = lighten("{color3}", 50),
  nord_blue = lighten("{color3}", 60),
  
  yellow = lighten("{color6}", 40),
  sun = lighten("{color6}", 50),
  
  purple = lighten("{color5}", 45),
  dark_purple = lighten("{color5}", 35),
  
  teal = lighten("{color2}", 50),
  cyan = lighten("{color2}", 60),
  
  orange = lighten("{color6}", 45),
  
  -- UI elements
  statusline_bg = lighten("{color0}", 4),
  lightbg = lighten("{color0}", 13),
  pmenu_bg = lighten("{color4}", 15),
  folder_bg = lighten("{color4}", 15),
}}

-- ============================================================================
-- BASE_16: Syntax Highlighting (base16 spec)
-- Colors boosted for readability against dark backgrounds
-- ============================================================================
M.base_16 = {{
  -- Background shades
  base00 = "{color0}",
  base01 = lighten("{color0}", 5),
  base02 = lighten("{color0}", 12),
  base03 = lighten("{color8}", 5),
  
  -- Foreground shades
  base04 = lighten("{color7}", -15),
  base05 = "{color7}",
  base06 = lighten("{color7}", 5),
  base07 = lighten("{color7}", 10),
  
  -- Syntax colors - HIGH CONTRAST (60-70% boost for bearded-arc level)
  base08 = lighten("{color5}", 45),   -- Variables, Tags (red/coral)
  base09 = lighten("{color6}", 45),   -- Constants, Numbers (orange)
  base0A = lighten("{color6}", 50),   -- Classes, Types (yellow)
  base0B = lighten("{color1}", 60),   -- Strings (green/teal)
  base0C = lighten("{color2}", 55),   -- RegEx, Escape chars (cyan)
  base0D = lighten("{color3}", 55),   -- Functions (blue)
  base0E = lighten("{color5}", 50),   -- Keywords (purple/pink)
  base0F = lighten("{color4}", 40),   -- Deprecated
}}

M.type = "dark"

-- ============================================================================
-- POLISH_HL: Fine-tuned overrides for better distinction
-- ============================================================================
M.polish_hl = {{
  treesitter = {{
    -- Operators/punctuation - subtle but visible
    ["@operator"] = {{ fg = M.base_30.cyan }},
    ["@punctuation.bracket"] = {{ fg = M.base_30.purple }},
    ["@punctuation.delimiter"] = {{ fg = M.base_30.grey_fg }},
    
    -- Variables - use foreground, not harsh accent
    ["@variable"] = {{ fg = M.base_16.base05 }},
    ["@variable.parameter"] = {{ fg = M.base_30.orange }},
    ["@variable.member"] = {{ fg = M.base_30.teal }},
    ["@variable.builtin"] = {{ fg = M.base_30.red }},
    
    -- Properties
    ["@property"] = {{ fg = M.base_30.teal }},
    
    -- Functions - bright and clear
    ["@function"] = {{ fg = M.base_30.blue }},
    ["@function.call"] = {{ fg = M.base_30.blue }},
    ["@function.method.call"] = {{ fg = M.base_30.nord_blue }},
    ["@function.builtin"] = {{ fg = M.base_30.cyan }},
    
    -- Constants
    ["@constant"] = {{ fg = M.base_30.orange }},
    ["@constant.builtin"] = {{ fg = M.base_30.sun }},
    
    -- Keywords - prominent
    ["@keyword"] = {{ fg = M.base_30.purple }},
    ["@keyword.return"] = {{ fg = M.base_30.pink }},
    ["@keyword.function"] = {{ fg = M.base_30.purple }},
    ["@keyword.conditional"] = {{ fg = M.base_30.purple }},
    ["@keyword.repeat"] = {{ fg = M.base_30.purple }},
    ["@keyword.operator"] = {{ fg = M.base_30.purple }},
    
    -- Types - distinct from keywords
    ["@type"] = {{ fg = M.base_30.yellow }},
    ["@type.builtin"] = {{ fg = M.base_30.sun }},
    
    -- Strings - green family
    ["@string"] = {{ fg = M.base_30.green }},
    ["@string.escape"] = {{ fg = M.base_30.cyan }},
    ["@string.regex"] = {{ fg = M.base_30.cyan }},
    
    -- Numbers
    ["@number"] = {{ fg = M.base_30.orange }},
    ["@number.float"] = {{ fg = M.base_30.orange }},
    ["@boolean"] = {{ fg = M.base_30.orange }},
  }},

  syntax = {{
    Operator = {{ fg = M.base_30.cyan }},
    String = {{ fg = M.base_30.green }},
    Number = {{ fg = M.base_30.orange }},
    Keyword = {{ fg = M.base_30.purple }},
    Function = {{ fg = M.base_30.blue }},
    Type = {{ fg = M.base_30.yellow }},
  }},

  defaults = {{
    Comment = {{ fg = M.base_30.light_grey, italic = true }},
  }},
}}

return M
