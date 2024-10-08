import { opt, mkOptions } from 'lib/option';
import { distro } from 'lib/variables';
import { icon } from 'lib/utils';
import icons from 'lib/icons';

export type FootConfig = {
    alpha: string;
    background: string;
    foreground: string;
    bright0: string;
    bright1: string;
    bright2: string;
    bright3: string;
    bright4: string;
    bright5: string;
    bright6: string;
    bright7: string;
    regular0: string;
    regular1: string;
    regular2: string;
    regular3: string;
    regular4: string;
    regular5: string;
    regular6: string;
    regular7: string;
    cursor: {
        inverseFg: string;
        bg: string;
    };
    selectionForeground: string;
    selectionBackground: string;
};

export type K9sSkin = {
    k9s: {
        body: {
            bgColor: string;
            fgColor: string;
            logoColor: string;
        };
        dialog: {
            bgColor: string;
            buttonBgColor: string;
            buttonFgColor: string;
            buttonFocusBgColor: string;
            buttonFocusFgColor: string;
            fgColor: string;
            fieldFgColor: string;
            labelFgColor: string;
        };
        frame: {
            border: {
                fgColor: string;
                focusColor: string;
            };
            crumbs: {
                activeColor: string;
                bgColor: string;
                fgColor: string;
            };
            menu: {
                fgColor: string;
                keyColor: string;
                numKeyColor: string;
            };
            status: {
                addColor: string;
                completedColor: string;
                errorColor: string;
                highlightColor: string;
                killColor: string;
                modifyColor: string;
                newColor: string;
                pendingColor: string;
            };
            title: {
                bgColor: string;
                counterColor: string;
                fgColor: string;
                filterColor: string;
                highlightColor: string;
            };
        };
        help: {
            bgColor: string;
            fgColor: string;
            keyColor: string;
            numKeyColor: string;
            sectionColor: string;
        };
        info: {
            fgColor: string;
            sectionColor: string;
        };
        prompt: {
            bgColor: string;
            fgColor: string;
            suggestColor: string;
        };
        views: {
            charts: {
                bgColor: string;
                chartBgColor: string;
                defaultChartColors: string[];
                defaultDialColors: string[];
                dialBgColor: string;
                resourceColors: {
                    cpu: string[];
                    mem: string[];
                };
            };
            logs: {
                bgColor: string;
                fgColor: string;
                indicator: {
                    bgColor: string;
                    fgColor: string;
                    toggleOffColor: string;
                    toggleOnColor: string;
                };
            };
            table: {
                bgColor: string;
                cursorBgColor: string;
                cursorFgColor: string;
                fgColor: string;
                header: {
                    bgColor: string;
                    fgColor: string;
                    sorterColor: string;
                };
                markColor: string;
            };
            xray: {
                bgColor: string;
                cursorColor: string;
                cursorTextColor: string;
                fgColor: string;
                graphicColor: string;
            };
            yaml: {
                colonColor: string;
                keyColor: string;
                valueColor: string;
            };
        };
    };
};

const options = mkOptions(OPTIONS, {
    autotheme: opt(false),

    wallpaper: {
        resolution: opt<import('service/wallpaper').Resolution>(1920),
        market: opt<import('service/wallpaper').Market>('random')
    },
    k9sSkin: opt<K9sSkin>({
        k9s: {
            body: {
                bgColor: 'default',
                fgColor: '#e4e1e9',
                logoColor: '#bec2ff'
            },
            dialog: {
                bgColor: '#46464f',
                buttonBgColor: '#3e4278',
                buttonFgColor: '#e0e0ff',
                buttonFocusBgColor: '#c5c4dd',
                buttonFocusFgColor: '#e1e0f9',
                fgColor: '#c7c5d0',
                fieldFgColor: '#e4e1e9',
                labelFgColor: '#c7c5d0'
            },
            frame: {
                border: {
                    fgColor: '#91909a',
                    focusColor: '#bec2ff'
                },
                crumbs: {
                    activeColor: '#e0e0ff',
                    bgColor: '#3e4278',
                    fgColor: '#e0e0ff'
                },
                menu: {
                    fgColor: '#e4e1e9',
                    keyColor: '#bec2ff',
                    numKeyColor: '#c5c4dd'
                },
                status: {
                    addColor: '#e8b9d5',
                    completedColor: '#46464f',
                    errorColor: '#ffb4ab',
                    highlightColor: '#c5c4dd',
                    killColor: '#ffb4ab',
                    modifyColor: '#bec2ff',
                    newColor: '#bec2ff',
                    pendingColor: '#c5c4dd'
                },
                title: {
                    bgColor: '#131318',
                    counterColor: '#bec2ff',
                    fgColor: '#e4e1e9',
                    filterColor: '#e8b9d5',
                    highlightColor: '#c5c4dd'
                }
            },
            help: {
                bgColor: '#131318',
                fgColor: '#e4e1e9',
                keyColor: '#bec2ff',
                numKeyColor: '#c5c4dd',
                sectionColor: '#e8b9d5'
            },
            info: {
                fgColor: '#c7c5d0',
                sectionColor: '#e4e1e9'
            },
            prompt: {
                bgColor: '#1f1f25',
                fgColor: '#e4e1e9',
                suggestColor: '#bec2ff'
            },
            views: {
                charts: {
                    bgColor: '#131318',
                    chartBgColor: '#1f1f25',
                    defaultChartColors: ['#bec2ff', '#c5c4dd'],
                    defaultDialColors: ['#bec2ff', '#c5c4dd'],
                    dialBgColor: '#1f1f25',
                    resourceColors: {
                        cpu: ['#bec2ff', '#e8b9d5'],
                        mem: ['#c5c4dd', '#ffb4ab']
                    }
                },
                logs: {
                    bgColor: '#131318',
                    fgColor: '#e4e1e9',
                    indicator: {
                        bgColor: '#1f1f25',
                        fgColor: '#c7c5d0',
                        toggleOffColor: '#91909a',
                        toggleOnColor: '#bec2ff'
                    }
                },
                table: {
                    bgColor: '#131318',
                    cursorBgColor: '#46464f',
                    cursorFgColor: '#c7c5d0',
                    fgColor: '#e4e1e9',
                    header: {
                        bgColor: '#1f1f25',
                        fgColor: '#c7c5d0',
                        sorterColor: '#bec2ff'
                    },
                    markColor: '#c5c4dd'
                },
                xray: {
                    bgColor: '#131318',
                    cursorColor: '#46464f',
                    cursorTextColor: '#c7c5d0',
                    fgColor: '#e4e1e9',
                    graphicColor: '#e8b9d5'
                },
                yaml: {
                    colonColor: '#91909a',
                    keyColor: '#bec2ff',
                    valueColor: '#e4e1e9'
                }
            }
        }
    }),
    foot: opt<FootConfig>({
        alpha: '.85',
        background: '#171717',
        foreground: '#eeeeee',
        bright0: '#585b70',
        bright1: '#f38ba8',
        bright2: '#a6e3a1',
        bright3: '#f9e2af',
        bright4: '#89b4fa',
        bright5: '#f5c2e7',
        bright6: '#94e2d5',
        bright7: '#bac2de',
        regular0: '#211f24',
        regular1: '#e55f86',
        regular2: '#a6e3a1',
        regular3: '#f9e2af',
        regular4: '#89b4fa',
        regular5: '#f5c2e7',
        regular6: '#94e2d5',
        regular7: '#bac2de',
        cursor: {
            inverseFg: '#a6e3a1',
            bg: '#a6e3a1'
        },
        selectionForeground: '#a6e3a1',
        selectionBackground: '#a6e3a1'
    }),
    theme: {
        dark: {
            primary: {
                bg: opt('#51a4e7'),
                fg: opt('#141414')
            },
            error: {
                bg: opt('#e55f86'),
                fg: opt('#141414')
            },
            bg: opt('#171717'),
            fg: opt('#eeeeee'),
            widget: opt('#eeeeee'),
            border: opt('#eeeeee')
        },
        light: {
            primary: {
                bg: opt('#426ede'),
                fg: opt('#eeeeee')
            },
            error: {
                bg: opt('#b13558'),
                fg: opt('#eeeeee')
            },
            bg: opt('#fffffa'),
            fg: opt('#080808'),
            widget: opt('#080808'),
            border: opt('#080808')
        },

        blur: opt(0),
        scheme: opt<'dark' | 'light'>('dark'),
        widget: { opacity: opt(94) },
        border: {
            width: opt(1),
            opacity: opt(96)
        },

        shadows: opt(true),
        padding: opt(7),
        spacing: opt(12),
        radius: opt(11)
    },

    transition: opt(200),

    font: {
        size: opt(13),
        name: opt('Ubuntu Nerd Font')
    },

    bar: {
        flatButtons: opt(true),
        position: opt<'top' | 'bottom'>('top'),
        corners: opt(50),
        transparent: opt(false),
        layout: {
            start: opt<Array<import('widget/bar/Bar').BarWidget>>([
                'launcher',
                'workspaces',
                'taskbar',
                'expander',
                'messages'
            ]),
            center: opt<Array<import('widget/bar/Bar').BarWidget>>(['date']),
            end: opt<Array<import('widget/bar/Bar').BarWidget>>([
                'media',
                'expander',
                'systray',
                'colorpicker',
                'screenrecord',
                'system',
                'battery',
                'powermenu'
            ])
        },
        launcher: {
            icon: {
                colored: opt(true),
                icon: opt(icon(distro.logo, icons.ui.search))
            },
            label: {
                colored: opt(false),
                label: opt(' Applications')
            },
            action: opt(() => App.toggleWindow('launcher'))
        },
        date: {
            format: opt('%H:%M - %A %e.'),
            action: opt(() => App.toggleWindow('datemenu'))
        },
        battery: {
            bar: opt<'hidden' | 'regular' | 'whole'>('regular'),
            charging: opt('#00D787'),
            percentage: opt(true),
            blocks: opt(7),
            width: opt(50),
            low: opt(30)
        },
        workspaces: {
            workspaces: opt(7)
        },
        taskbar: {
            iconSize: opt(0),
            monochrome: opt(true),
            exclusive: opt(false)
        },
        messages: {
            action: opt(() => App.toggleWindow('datemenu'))
        },
        systray: {
            ignore: opt(['KDE Connect Indicator', 'spotify-client'])
        },
        media: {
            monochrome: opt(true),
            preferred: opt('spotify'),
            direction: opt<'left' | 'right'>('right'),
            format: opt('{artists} - {title}'),
            length: opt(40)
        },
        powermenu: {
            monochrome: opt(false),
            action: opt(() => App.toggleWindow('powermenu'))
        }
    },

    launcher: {
        width: opt(0),
        margin: opt(80),
        nix: {
            pkgs: opt('nixpkgs/nixos-unstable'),
            max: opt(8)
        },
        sh: {
            max: opt(16)
        },
        apps: {
            iconSize: opt(62),
            max: opt(6),
            favorites: opt([
                [
                    'firefox',
                    'wezterm',
                    'org.gnome.Nautilus',
                    'org.gnome.Calendar',
                    'spotify'
                ]
            ])
        }
    },

    overview: {
        scale: opt(9),
        workspaces: opt(7),
        monochromeIcon: opt(true)
    },

    powermenu: {
        sleep: opt('systemctl suspend'),
        reboot: opt('systemctl reboot'),
        logout: opt('pkill Hyprland'),
        shutdown: opt('shutdown now'),
        layout: opt<'line' | 'box'>('line'),
        labels: opt(true)
    },

    quicksettings: {
        avatar: {
            image: opt(`/var/lib/AccountsService/icons/${Utils.USER}`),
            size: opt(70)
        },
        width: opt(380),
        position: opt<'left' | 'center' | 'right'>('right'),
        networkSettings: opt('gtk-launch gnome-control-center'),
        media: {
            monochromeIcon: opt(true),
            coverSize: opt(100)
        }
    },

    datemenu: {
        position: opt<'left' | 'center' | 'right'>('center'),
        weather: {
            interval: opt(60_000),
            unit: opt<'metric' | 'imperial' | 'standard'>('metric'),
            key: opt<string>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || '{}')
                    ?.key || ''
            ),
            cities: opt<Array<number>>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || '{}')
                    ?.cities || []
            )
        }
    },

    osd: {
        progress: {
            vertical: opt(true),
            pack: {
                h: opt<'start' | 'center' | 'end'>('end'),
                v: opt<'start' | 'center' | 'end'>('center')
            }
        },
        microphone: {
            pack: {
                h: opt<'start' | 'center' | 'end'>('center'),
                v: opt<'start' | 'center' | 'end'>('end')
            }
        }
    },

    notifications: {
        position: opt<Array<'top' | 'bottom' | 'left' | 'right'>>([
            'top',
            'right'
        ]),
        blacklist: opt(['Spotify']),
        width: opt(440)
    },

    hyprland: {
        gaps: opt(2.4),
        inactiveBorder: opt('#282828'),
        gapsWhenOnly: opt(false)
    }
});

globalThis['options'] = options;
export default options;
