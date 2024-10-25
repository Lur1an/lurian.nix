import options, { Colors } from 'options';
import { sh } from './utils';

const deps = ['colors'];

function generateKittyColors(colors: Colors): string {
    return `
cursor ${colors.on_surface}
cursor_text_color ${colors.on_surface_variant}

foreground            ${colors.on_surface}
background            ${colors.surface}
selection_foreground  ${colors.on_secondary}
selection_background  ${colors.secondary_fixed_dim}
url_color             ${colors.primary}

# black
color8   #262626
color0   #4c4c4c

# red
color1   #ac8a8c
color9   #c49ea0

# green
color2   #8aac8b
color10  #9ec49f

# yellow
color3   #aca98a
color11  #c4c19e

# blue
/* color4  #8f8aac */
color4  ${colors.primary}
color12 #a39ec4

# magenta
color5   #ac8aac
color13  #c49ec4

# cyan
color6   #8aacab
color14  #9ec3c4

# white
color15   #e7e7e7
color7  #f0f0f0
    `;
}

async function setupKitty() {
    const colors = options.colors.value;
    const kittyColors = generateKittyColors(colors);
    try {
        await Utils.writeFile(
            kittyColors,
            '/home/lurian/.config/kitty/colors.conf'
        );
        await sh("pkill -USR1 kitty");
    } catch (error) {
        console.error(`Failed to write foot config: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupKitty);
    setupKitty();
}
