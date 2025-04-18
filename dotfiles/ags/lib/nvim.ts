import options, { MaterialColors } from 'options';
import { sh } from './utils';

const deps = ['colors'];

async function setupNvimTheme() {
    const colors = options.colors.value;
    const skin: string = generateNvimMaterialTheme(colors);
    try {
        await sh(`mkdir -p /home/lurian/lurian.nix/dotfiles/nvim/lua/themes`);
        await sh ("touch /home/lurian/lurian.nix/dotfiles/nvim/lua/themes/matugen.lua");
        await Utils.writeFile(
            skin,
            '/home/lurian/lurian.nix/dotfiles/nvim/lua/themes/matugen.lua'
        );
    } catch (error) {
        console.error(`Failed to serialize and write k9s skin: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupNvimTheme);
    setupNvimTheme();
}

function generateNvimMaterialTheme(colors: MaterialColors): string {
    return `
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '${colors.on_surface}',
  black = '${colors.surface}',
  darker_black = lighten('${colors.background}', -3),
  black2 = lighten('${colors.background}', 6),
  one_bg = lighten('${colors.background}', 10),
  one_bg2 = lighten('${colors.background}', 16),
  one_bg3 = lighten('${colors.background}', 22),

  grey = '${colors.surface_variant}',
  grey_fg = lighten('${colors.surface_variant}', -10),
  grey_fg2 = lighten('${colors.surface_variant}', -20),
  light_grey = '${colors.outline}',

  red = '${colors.error}',
  baby_pink = lighten('${colors.error}', 10),
  pink = '${colors.tertiary}',

  line = '${colors.outline}',

  green = '${colors.secondary}',
  vibrant_green = lighten('${colors.secondary}', 10),

  blue = '${colors.primary}',
  nord_blue = lighten('${colors.primary}', 10),

  yellow = lighten('${colors.tertiary}', 10),
  sun = lighten('${colors.tertiary}', 20),

  purple = '${colors.tertiary}',
  dark_purple = lighten('${colors.tertiary}', -10),

  teal = '${colors.secondary_container}',
  orange = '${colors.error}',
  cyan = '${colors.secondary}',

  statusline_bg = lighten('${colors.background}', 6),
  pmenu_bg = '${colors.surface_variant}',
  folder_bg = lighten('${colors.primary_fixed_dim}', 0),
}

M.base_16 = {
  base00 = '${colors.surface}',                   -- Default Background
  base01 = lighten('${colors.surface_variant}', 0),       -- Lighter Background (status bars)
  base02 = '${colors.secondary_fixed_dim}',              -- Selection Background
  base03 = lighten('${colors.outline}', 0),           -- Comments, Invisibles, Line Highlighting
  base04 = lighten('${colors.on_surface_variant}', 0),  -- Dark Foreground (status bars)
  base05 = '${colors.on_surface}',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('${colors.on_surface}', 0),   -- Light Foreground (Not often used)
  base07 = '${colors.surface}',               -- Light Background (Not often used)
  base08 = lighten('${colors.on_primary_container}', -10),                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '${colors.tertiary}',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '${colors.primary}',                     -- Classes, Markup Bold, Search Text Background
  base0B = '${colors.tertiary_fixed}',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '${colors.primary_fixed_dim}',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = lighten('${colors.primary_container}', 20),                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '${colors.on_primary_container}',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '${colors.inverse_surface}',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
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
      fg = '${colors.on_tertiary_container}'
    }
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = '${colors.on_tertiary_container}'
    },
  }
}

return M`;
}
