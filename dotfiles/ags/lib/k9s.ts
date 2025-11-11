import options, { MaterialColors } from 'options';
import { dump } from 'js-yaml';

const deps = ['colors'];

function generateK9sSkin(c: MaterialColors) {
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
                    bgColor: 'default',
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

async function setupK9s() {
    const colors = options.colors.value;
    const skin = generateK9sSkin(colors);
    try {
        // await Utils.writeFile(
        //     dump(skin),
        //     '/home/lurian/.config/k9s/skins/matugen.yaml'
        // );
        console.info('Updated k9s skin');
    } catch (error) {
        console.error(`Failed to serialize and write k9s skin: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupK9s);
    setupK9s();
}
