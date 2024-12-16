import options from "options"
import { sh } from "./utils"

export async function tmux() {
    if (await sh("which tmux").catch(() => false))
        sh(`tmux source ~/.config/tmux/tmux.conf`)
}

export default function init() {
    options.theme.dark.primary.bg.connect("changed", tmux)
    options.theme.light.primary.bg.connect("changed", tmux)
}
