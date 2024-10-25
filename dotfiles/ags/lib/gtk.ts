import Gio from 'gi://Gio';
import options, { MaterialColors } from 'options';

const settings = new Gio.Settings({
    schema: 'org.gnome.desktop.interface'
});

function gtk() {
    const scheme = options.theme.scheme.value;
    settings.set_string('color-scheme', `prefer-${scheme}`);
}

const deps = ['colors'];

function generateGtkColorsCSS(c: MaterialColors) {
    return `
@define-color accent_color ${c.primary_fixed_dim};
@define-color accent_fg_color ${c.on_primary_fixed};
@define-color accent_bg_color ${c.primary_fixed_dim};
@define-color window_bg_color ${c.surface_dim};
@define-color window_fg_color ${c.on_surface};
@define-color headerbar_bg_color ${c.surface_dim};
@define-color headerbar_fg_color ${c.on_surface};
@define-color popover_bg_color ${c.surface_dim};
@define-color popover_fg_color ${c.on_surface};
@define-color view_bg_color ${c.surface};
@define-color view_fg_color ${c.on_surface};
@define-color card_bg_color ${c.surface};
@define-color card_fg_color ${c.on_surface};
@define-color sidebar_bg_color @window_bg_color;
@define-color sidebar_fg_color @window_fg_color;
@define-color sidebar_border_color @window_bg_color;
@define-color sidebar_backdrop_color @window_bg_color;
    `;
}

async function gtkColors() {
    const colors = options.colors.value;
    const css = generateGtkColorsCSS(colors);
    try {
        await Utils.writeFile(css, '/home/lurian/.config/gtk-4.0/matugen.css');
        await Utils.writeFile(css, '/home/lurian/.config/gtk-3.0/matugen.css');
    } catch (error) {
        console.error(`Failed to serialize and write gtk colors: ${error}`);
    }
}

export default function init() {
    options.theme.scheme.connect('changed', gtk);
    options.handler(deps, gtkColors);
    gtk();
}
