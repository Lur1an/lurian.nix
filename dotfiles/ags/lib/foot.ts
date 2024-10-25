import options, { MaterialColors } from 'options';
import { sh } from './utils';

const deps = ['colors'];

function generateFootSkin(c: MaterialColors) {
    return {
        alpha: '.85',
        background: c.background,
        foreground: c.on_surface,

        regular0: c.surface_container,
        regular1: c.error,
        regular2: c.primary,
        regular3: c.inverse_primary,
        regular4: c.primary,
        regular5: c.tertiary,
        regular6: c.secondary,
        regular7: c.on_primary,

        bright0: c.surface_variant,
        bright1: c.error_container,
        bright2: c.on_primary_container,
        bright3: c.on_secondary_container,
        bright4: c.on_tertiary_container,
        bright5: c.inverse_surface,
        bright6: c.outline,
        bright7: c.inverse_primary,
        cursor: {
            inverseFg: c.on_primary,
            bg: c.primary
        },
        selectionForeground: c.on_primary,
        selectionBackground: c.primary
    };
}

async function setupFoot() {
    const colors = options.colors.value;
    const foot = generateFootSkin(colors);
    const footConfigFile = `
[colors]
alpha=${foot.alpha}
background=${foot.background}
foreground=${foot.foreground}
regular0=${foot.regular0}
regular1=${foot.regular1}
regular2=${foot.regular2}
regular3=${foot.regular3}
regular4=${foot.regular4}
regular5=${foot.regular5}
regular6=${foot.regular6}
regular7=${foot.regular7}

bright0=${foot.bright0}
bright1=${foot.bright1}
bright2=${foot.bright2}
bright3=${foot.bright3}
bright4=${foot.bright4} 
bright5=${foot.bright5}
bright6=${foot.bright6}
bright7=${foot.bright7}

[cursor]
color=${foot.cursor.inverseFg}  ${foot.cursor.bg}
style=beam

[main]
dpi-aware=no
font=ComicCodeLigatures Nerd Font:size=12
pad=10x5 center
term=xterm-256color

[tweak]
sixel=yes
    `;
    try {
        await sh("mkdir -p /home/lurian/.config/foot");
        await Utils.writeFile(
            footConfigFile.replaceAll('#', ''),
            '/home/lurian/.config/foot/foot.ini'
        );
    } catch (error) {
        console.error(`Failed to write foot config: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupFoot);
    setupFoot();
}
