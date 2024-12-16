import matugen from "./matugen"
import hyprland from "./hyprland"
import foot from "./foot"
import k9s from "./k9s"
import tmux from "./tmux"
import kitty from "./kitty"
import discord from "./discord"
import nvim from "./nvim"
import gtk from "./gtk"
import lowBattery from "./battery"
import notifications from "./notifications"

export default function init() {
    try {
        gtk()
        //tmux()
        matugen()
        lowBattery()
        notifications()
        hyprland()
        discord()
        nvim()
        //foot()
        //kitty()
        k9s()
    } catch (error) {
        logError(error)
    }
}
