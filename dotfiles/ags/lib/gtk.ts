import Gio from "gi://Gio"
import options, { Colors } from "options"

const settings = new Gio.Settings({
    schema: "org.gnome.desktop.interface",
})

function gtk() {
    const scheme = options.theme.scheme.value
    settings.set_string("color-scheme", `prefer-${scheme}`)
}

const deps = ['colors'];

function generateGtk4ColorsCSS(c: Colors) {
    return `
/* GTK4 Theme Colors */
:root {
    /* Accent Colors */
    --accent-color: ${c.primary_fixed_dim};
    --accent-fg-color: ${c.on_primary_fixed};
    --accent-bg-color: ${c.primary_fixed_dim};

    /* Window Colors */
    --window-bg-color: ${c.surface_dim};
    --window-fg-color: ${c.on_surface};

    /* Header Bar Colors */
    --headerbar-bg-color: ${c.surface_dim};
    --headerbar-fg-color: ${c.on_surface};

    /* Popover Colors */
    --popover-bg-color: ${c.surface_dim};
    --popover-fg-color: ${c.on_surface};

    /* View Colors */
    --view-bg-color: ${c.surface};
    --view-fg-color: ${c.on_surface};

    /* Card Colors */
    --card-bg-color: ${c.surface};
    --card-fg-color: ${c.on_surface};

    /* Sidebar Colors */
    --sidebar-bg-color: var(--window-bg-color);
    --sidebar-fg-color: var(--window-fg-color);
    --sidebar-border-color: var(--window-bg-color);
    --sidebar-backdrop-color: var(--window-bg-color);

    /* Text Colors */
    --text-color: ${c.on_surface};
    --text-color-dim: ${c.on_surface_variant};
    --text-color-bright: ${c.on_surface_variant};

    /* Other Colors */
    --error-color: ${c.error};
    --success-color: ${c.tertiary};
    --warning-color: ${c.secondary};
    --outline-color: ${c.outline};

    /* Surface Colors */
    --surface-color: ${c.surface};
    --surface-bright-color: ${c.surface_bright};
    --surface-dim-color: ${c.surface_dim};
    --surface-container-color: ${c.surface_container};
    --surface-container-high-color: ${c.surface_container_high};
    --surface-container-highest-color: ${c.surface_container_highest};
    --surface-container-low-color: ${c.surface_container_low};
    --surface-container-lowest-color: ${c.surface_container_lowest};

    /* Additional Colors can be added here */
}
`;
}

function generateGtkColorsCSS(c: Colors) {
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
    `
}

async function gtkColors() {
    const colors = options.colors.value;
    const css = generateGtkColorsCSS(colors);
    try {
        await Utils.writeFile(
            css,
            '/home/lurian/.config/gtk-4.0/colors.css'
        );
        await Utils.writeFile(
            css,
            '/home/lurian/.config/gtk-3.0/colors.css'
        );
        console.info('Updated gtk colors');
    } catch (error) {
        console.error(`Failed to serialize and write gtk colors: ${error}`);
    }
}

export default function init() {
    options.theme.scheme.connect("changed", gtk)
    options.handler(deps, gtkColors)
    gtk()
}
