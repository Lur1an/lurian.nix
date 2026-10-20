# hyprwinwrap

Locally maintained wallpaper-window plugin, restored from this repository's
vendored copy before commit `b5c24a9`. The original source came from
`hyprwm/hyprland-plugins` at `eaf18d5` (before upstream removed the plugin).

Builds with the same Hyprland package and compiler as the compositor. Updated for
Hyprland `f6e3a723abdbe64e2d0b36fda9f8985e5b6e040e`: window metadata/state,
layout targets, render contexts/presentations, configuration values, and the
`commitWindow(bool)` hook ABI. Future Hyprland updates may require another port.

The existing Lua configuration is supported:

```lua
hl.plugin.hyprwinwrap.window({
    class = "mpv",
    -- Class and title are exact matches. Either may be supplied.
    -- Position and size are monitor-relative percentages.
    pos_x = 0,
    pos_y = 0,
    size_x = 100,
    size_y = 100,
})
```

Legacy `hl.config({ plugin = { hyprwinwrap = { ... } } })` settings also work
with the same fields as strings. The legacy default class is `kitty-bg`.

Build with `nix build .#hyprwinwrap`. After activating a system using the matching
Hyprland revision, restart the session and check `hyprctl plugin list`, then
launch an `mpv` window and check wallpaper rendering and config reloads.
