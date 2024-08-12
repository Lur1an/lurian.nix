import matugen from "./matugen"
import hyprland from "./hyprland"
import foot from "./foot"
import tmux from "./tmux"
import gtk from "./gtk"
import lowBattery from "./battery"
import notifications from "./notifications"

export default function init() {
    try {
        gtk()
        tmux()
        matugen()
        lowBattery()
        notifications()
        hyprland()
        foot()
    } catch (error) {
        logError(error)
    }
}
