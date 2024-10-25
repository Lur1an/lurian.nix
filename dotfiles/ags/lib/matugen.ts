import wallpaper from 'service/wallpaper';
import options, { MaterialColors } from 'options';
import { sh, dependencies } from './utils';

export default function init() {
    wallpaper.connect('changed', () => matugen());
    options.autotheme.connect('changed', () => matugen());
}

function animate(...setters: Array<() => void>) {
    const delay = options.transition.value / 2;
    setters.forEach((fn, i) => Utils.timeout(delay * i, fn));
}

export async function matugen(
    type: 'image' | 'color' = 'image',
    arg = wallpaper.wallpaper
) {
    if (!options.autotheme.value || !dependencies('matugen')) return;

    const colors = await sh(`matugen --dry-run -j hex ${type} ${arg}`);
    const c = JSON.parse(colors).colors as { light: MaterialColors; dark: MaterialColors };
    const { dark, light } = options.theme;
    animate(
        () => {
            options.colors.value =
                options.theme.scheme.value === 'dark' ? c.dark : c.light;
        },
        () => {
            dark.widget.value = c.dark.on_surface;
            light.widget.value = c.light.on_surface;
        },
        () => {
            dark.border.value = c.dark.outline;
            light.border.value = c.light.outline;
        },
        () => {
            dark.bg.value = c.dark.surface;
            light.bg.value = c.light.surface;
        },
        () => {
            dark.fg.value = c.dark.on_surface;
            light.fg.value = c.light.on_surface;
        },
        () => {
            dark.primary.bg.value = c.dark.primary;
            light.primary.bg.value = c.light.primary;
            options.bar.battery.charging.value =
                options.theme.scheme.value === 'dark'
                    ? c.dark.primary
                    : c.light.primary;
        },
        () => {
            dark.primary.fg.value = c.dark.on_primary;
            light.primary.fg.value = c.light.on_primary;
        },
        () => {
            dark.error.bg.value = c.dark.error;
            light.error.bg.value = c.light.error;
        },
        () => {
            dark.error.fg.value = c.dark.on_error;
            light.error.fg.value = c.light.on_error;
        }
    );
}
