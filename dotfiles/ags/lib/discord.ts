import options, { MaterialColors } from 'options';

const deps = ['colors'];


async function setupDiscordCSS() {
    const colors = options.colors.value;
    // const skin: string = generateDiscordCSS(colors);
    // try {
    //     await Utils.writeFile(
    //         skin,
    //         '/home/lurian/.config/vesktop/settings/quickCss.css'
    //     );
    //     console.info('Updated discord skin');
    // } catch (error) {
    //     console.error(`Failed to serialize and write k9s skin: ${error}`);
    // }
}

export default function init() {
    options.handler(deps, setupDiscordCSS);
    setupDiscordCSS();
}

function generateDiscordCSS(colors: MaterialColors): string {
    return `
        @import url('https://refact0r.github.io/midnight-discord/midnight.css');

        /* customize things here */
        :root {
            /* font, change to 'gg sans' for default discord font*/
            --font: 'gg sans';

            /* top left corner text */
            --corner-text: 'Midnight';

            /* color of status indicators and window controls */
            --online-indicator: ${colors.inverse_primary};     /* change to #23a55a for default green */
            --dnd-indicator: ${colors.error};                  /* change to #f13f43 for default red */
            --idle-indicator: ${colors.tertiary_container};    /* change to #f0b232 for default yellow */
            --streaming-indicator: ${colors.on_primary};       /* change to #593695 for default purple */

            /* accent colors */
            --accent-1: ${colors.tertiary};            /* links */
            --accent-2: ${colors.primary};             /* general unread/mention elements, some icons when active */
            --accent-3: ${colors.primary};             /* accent buttons */
            --accent-4: ${colors.surface_bright};      /* accent buttons when hovered */
            --accent-5: ${colors.primary_fixed_dim};   /* accent buttons when clicked */
            --mention:  ${colors.surface};             /* mentions & mention messages */
            --mention-hover: ${colors.surface_bright}; /* mentions & mention messages when hovered */

            /* text colors */
            --text-0: ${colors.surface};               /* text on colored elements */
            --text-1: ${colors.on_surface};            /* other normally white text */
            --text-2: ${colors.on_surface};            /* headings and important text */
            --text-3: ${colors.on_surface_variant};    /* normal text */
            --text-4: ${colors.on_surface_variant};    /* icon buttons and channels */
            --text-5: ${colors.outline};               /* muted channels/chats and timestamps */

            /* background and dark colors */
            --bg-1: ${colors.primary};                             /* dark buttons when clicked */
            --bg-2: ${colors.surface_container_high};              /* dark buttons */
            --bg-3: ${colors.surface_container_low};               /* spacing, secondary elements */
            --bg-4: ${colors.surface};                             /* main background color */
            --hover: ${colors.surface_bright};                     /* channels and buttons when hovered */
            --active: ${colors.surface_bright};                    /* channels and buttons when clicked or selected */
            --message-hover: ${colors.surface_bright};             /* messages when hovered */

            /* amount of spacing and padding */
            --spacing: 12px;

            /* animations */
            /* ALL ANIMATIONS CAN BE DISABLED WITH REDUCED MOTION IN DISCORD SETTINGS */
            --list-item-transition: 0.2s ease;  /* channels/members/settings hover transition */
            --unread-bar-transition: 0.2s ease; /* unread bar moving into view transition */
            --moon-spin-transition: 0.4s ease;  /* moon icon spin */
            --icon-spin-transition: 1s ease;    /* round icon button spin (settings, emoji, etc.) */

            /* corner roundness (border-radius) */
            --roundness-xl: 22px; /* roundness of big panel outer corners */
            --roundness-l: 20px; /* popout panels */
            --roundness-m: 16px; /* smaller panels, images, embeds */
            --roundness-s: 12px; /* members, settings inputs */
            --roundness-xs: 10px; /* channels, buttons */
            --roundness-xxs: 8px; /* searchbar, small elements */

            /* direct messages moon icon */
            /* change to block to show, none to hide */
            --discord-icon: none; /* discord icon */
            --moon-icon: block; /* moon icon */
            --moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg'); /* custom icon url */
            --moon-icon-size: auto;

            /* filter uncolorable elements to fit theme */
            /* (just set to none, they're too much work to configure) */
            --login-bg-filter: saturate(0.3) hue-rotate(-15deg) brightness(0.4); /* login background artwork */
            --green-to-accent-3-filter: hue-rotate(56deg) saturate(1.43); /* add friend page explore icon */
            --blurple-to-accent-3-filter: hue-rotate(304deg) saturate(0.84) brightness(1.2); /* add friend page school icon */
        }

        /* Selected chat/friend text */
        .selected_f5eb4b,
        .selected_f6f816 .link_d8bfb3 {
          color: var(--text-0) !important;
          background: var(--accent-3) !important;
        }

        .selected_f6f816 .link_d8bfb3 * {
          color: var(--text-0) !important;
          fill: var(--text-0) !important;
        }
    `;
}
