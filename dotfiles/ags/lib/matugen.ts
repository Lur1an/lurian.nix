import wallpaper from 'service/wallpaper';
import options, { FootConfig, K9sSkin } from 'options';
import { sh, dependencies } from './utils';

export default function init() {
    wallpaper.connect('changed', () => matugen());
    options.autotheme.connect('changed', () => matugen());
}

function generateFootSkin(c: Colors): FootConfig {
    return {
        alpha: '.85',
        background: c.surface,
        foreground: c.on_surface,

        regular0: c.surface_container,
        regular1: c.error,
        regular2: c.primary,
        regular3: c.secondary,
        regular4: c.tertiary,
        regular5: c.on_background,
        regular6: c.primary_container,
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

function generateK9sSkin(c: Colors): K9sSkin {
    return {
        k9s: {
            body: {
                bgColor: 'default',
                fgColor: c.on_surface,
                logoColor: c.primary
            },
            dialog: {
                bgColor: c.surface_variant,
                buttonBgColor: c.primary_container,
                buttonFgColor: c.on_primary_container,
                buttonFocusBgColor: c.secondary_container,
                buttonFocusFgColor: c.on_secondary_container,
                fgColor: c.on_surface_variant,
                fieldFgColor: c.on_surface,
                labelFgColor: c.on_surface_variant
            },
            frame: {
                border: {
                    fgColor: c.outline,
                    focusColor: c.primary
                },
                crumbs: {
                    activeColor: c.on_primary_container,
                    bgColor: c.primary_container,
                    fgColor: c.on_primary_container
                },
                menu: {
                    fgColor: c.on_surface,
                    keyColor: c.tertiary,
                    numKeyColor: c.secondary
                },
                status: {
                    addColor: c.tertiary,
                    completedColor: c.surface_variant,
                    errorColor: c.error,
                    highlightColor: c.secondary,
                    killColor: c.error,
                    modifyColor: c.primary,
                    newColor: c.primary,
                    pendingColor: c.secondary
                },
                title: {
                    bgColor: c.surface,
                    counterColor: c.primary,
                    fgColor: c.on_surface,
                    filterColor: c.tertiary,
                    highlightColor: c.secondary
                }
            },
            help: {
                bgColor: c.surface,
                fgColor: c.on_surface,
                keyColor: c.primary,
                numKeyColor: c.secondary,
                sectionColor: c.tertiary
            },
            info: {
                fgColor: c.on_surface_variant,
                sectionColor: c.on_surface
            },
            prompt: {
                bgColor: c.surface_container,
                fgColor: c.on_surface,
                suggestColor: c.primary
            },
            views: {
                charts: {
                    bgColor: c.surface,
                    chartBgColor: c.surface_container,
                    defaultChartColors: [c.primary, c.secondary],
                    defaultDialColors: [c.primary, c.secondary],
                    dialBgColor: c.surface_container,
                    resourceColors: {
                        cpu: [c.primary, c.tertiary],
                        mem: [c.secondary, c.error]
                    }
                },
                logs: {
                    bgColor: c.surface,
                    fgColor: c.on_surface,
                    indicator: {
                        bgColor: c.surface_container,
                        fgColor: c.on_surface_variant,
                        toggleOffColor: c.outline,
                        toggleOnColor: c.primary
                    }
                },
                table: {
                    bgColor: "default",
                    cursorBgColor: c.surface_variant,
                    cursorFgColor: c.on_secondary,
                    fgColor: c.on_surface,
                    header: {
                        bgColor: c.surface_container,
                        fgColor: c.on_surface_variant,
                        sorterColor: c.primary
                    },
                    markColor: c.secondary
                },
                xray: {
                    bgColor: c.surface,
                    cursorColor: c.surface_variant,
                    cursorTextColor: c.on_surface_variant,
                    fgColor: c.on_surface,
                    graphicColor: c.tertiary
                },
                yaml: {
                    colonColor: c.outline,
                    keyColor: c.primary,
                    valueColor: c.on_surface
                }
            }
        }
    };
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
    const c = JSON.parse(colors).colors as { light: Colors; dark: Colors };
    const { dark, light } = options.theme;
    const foot = options.foot;
    const k9sSkin = options.k9sSkin;
    animate(
        () => {
            k9sSkin.value = generateK9sSkin(c.dark);
        },
        () => {
            foot.value = generateFootSkin(c.dark);
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

type Colors = {
    background: string;
    error: string;
    error_container: string;
    inverse_on_surface: string;
    inverse_primary: string;
    inverse_surface: string;
    on_background: string;
    on_error: string;
    on_error_container: string;
    on_primary: string;
    on_primary_container: string;
    on_primary_fixed: string;
    on_primary_fixed_variant: string;
    on_secondary: string;
    on_secondary_container: string;
    on_secondary_fixed: string;
    on_secondary_fixed_variant: string;
    on_surface: string;
    on_surface_variant: string;
    on_tertiary: string;
    on_tertiary_container: string;
    on_tertiary_fixed: string;
    on_tertiary_fixed_variant: string;
    outline: string;
    outline_variant: string;
    primary: string;
    primary_container: string;
    primary_fixed: string;
    primary_fixed_dim: string;
    scrim: string;
    secondary: string;
    secondary_container: string;
    secondary_fixed: string;
    secondary_fixed_dim: string;
    shadow: string;
    surface: string;
    surface_bright: string;
    surface_container: string;
    surface_container_high: string;
    surface_container_highest: string;
    surface_container_low: string;
    surface_container_lowest: string;
    surface_dim: string;
    surface_variant: string;
    tertiary: string;
    tertiary_container: string;
    tertiary_fixed: string;
    tertiary_fixed_dim: string;
};
