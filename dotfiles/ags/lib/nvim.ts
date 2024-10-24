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
  white = '${colors.on_surface}',
  darker_black = lighten('${colors.background}', -3),
  black = '${colors.background}',
  black2 = lighten('${colors.background}', 6),
  one_bg = lighten('${colors.background}', 10),
  grey = lighten('${colors.background}', 40),
  light_grey = '${colors.surface_variant}',
  red = '${colors.error}',
  baby_pink = '${colors.error_container}',
  pink = '${colors.inverse_primary}',
  line = '${colors.surface_variant}',
  green = '${colors.primary}',
  vibrant_green = '${colors.primary_container}',
  nord_blue = '${colors.tertiary}',
  blue = '${colors.tertiary}',
  yellow = '${colors.secondary}',
  sun = lighten('${colors.secondary}', 6),
  purple = '${colors.inverse_primary}',
  dark_purple = '${colors.inverse_primary}',
  teal = '${colors.tertiary}',
  orange = '${colors.error}',
  cyan = '${colors.secondary_container}',
  pmenu_bg = '${colors.surface_variant}',
  folder_bg = '${colors.tertiary}',
}

M.base_30.statusline_bg = M.base_30.black2
M.base_30.lightbg = M.base_30.one_bg
M.base_30.one_bg2 = lighten(M.base_30.one_bg, 6)
M.base_30.one_bg3 = lighten(M.base_30.one_bg2, 6)
M.base_30.grey_fg = lighten(M.base_30.grey, 10)
M.base_30.grey_fg2 = lighten(M.base_30.grey, 5)

M.base_16 = {
  base00 = '${colors.background}',
  base01 = '${colors.background}',
  base02 = '${colors.surface_variant}',
  base03 = '${colors.surface_variant}',
  base04 = '${colors.on_surface}',
  base05 = '${colors.on_surface}',
  base06 = '${colors.on_surface_variant}',
  base07 = '${colors.on_surface_variant}',
  base08 = '${colors.error}',
  base09 = '${colors.primary}',
  base0A = '${colors.secondary}',
  base0B = '${colors.tertiary}',
  base0C = '${colors.primary_container}',
  base0D = '${colors.secondary_container}',
  base0E = '${colors.error}',
  base0F = '${colors.on_surface_variant}',
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
    `;
}
