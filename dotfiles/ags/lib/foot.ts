import options from "options"

const {
    foot
} = options

const deps = [
    "terminal",
    "theme"
]

async function setupFoot() {
    const footConfig = `
[colors]
alpha=${foot.alpha}
background=${foot.background}
foreground=${foot.foreground}
bright0=${foot.bright0}
bright1=${foot.bright1}
bright2=${foot.bright2}
bright3=${foot.bright3}
bright4=${foot.bright4}
bright5=${foot.bright5}
bright6=${foot.bright6}
bright7=${foot.bright7}
regular0=${foot.regular0}
regular1=${foot.regular1}
regular2=${foot.regular2}
regular3=${foot.regular3}
regular4=${foot.regular4}
regular5=${foot.regular5}
regular6=${foot.regular6}
regular7=${foot.regular7}

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
        Utils.writeFileSync(footConfig.replaceAll("#", ""), "/home/lurian/.config/foot/foot.ini")
        console.log("foot config written", foot)
    } catch (error) {
        console.error(`Failed to write foot config: ${error}`)
    }
}

export default function init() {
    options.handler(deps, setupFoot)
    setupFoot()
}
