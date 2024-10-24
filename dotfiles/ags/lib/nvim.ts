import options, { Colors } from 'options';

const deps = ['colors'];


async function setupNvimTheme() {
    const colors = options.colors.value;
    const skin: string = generateNvimTheme(colors);
    try {
        await Utils.writeFile(
            skin,
            '/home/lurian/lurian.nix/dotfiles/nvim/lua/themes/auto.lua'
        );
        console.info('Updated discord skin');
    } catch (error) {
        console.error(`Failed to serialize and write k9s skin: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupNvimTheme);
    setupNvimTheme();
}

function generateNvimTheme(colors: Colors): string {
    return `
local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '${colors.on_background}',
  black = '${colors.background}',
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
  folder_bg = '${colors.primary_container}',
}

M.base_16 = {
  base00 = '${colors.background}',                   -- Default Background
  base01 = lighten('${colors.background}', 5),       -- Lighter Background (status bars)
  base02 = '${colors.surface_variant}',              -- Selection Background
  base03 = '${colors.outline}',                      -- Comments, Invisibles, Line Highlighting
  base04 = lighten('${colors.on_background}', -20),  -- Dark Foreground (status bars)
  base05 = '${colors.on_background}',                -- Default Foreground, Caret, Delimiters, Operators
  base06 = lighten('${colors.on_background}', 20),   -- Light Foreground (Not often used)
  base07 = '${colors.surface_bright}',               -- Light Background (Not often used)
  base08 = '${colors.error}',                        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '${colors.secondary}',                    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '${colors.tertiary}',                     -- Classes, Markup Bold, Search Text Background
  base0B = '${colors.primary}',                      -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '${colors.secondary}',                    -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = '${colors.primary}',                      -- Functions, Methods, Attribute IDs, Headings
  base0E = '${colors.tertiary}',                     -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '${colors.error}',                        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
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
    `;
}
