# Quickshell wallpaper picker

`Super+V` (or `wallpaper-picker`) toggles a floating, searchable media library.
Use Ctrl+N/P or Up/Down to navigate, Enter to apply, and Escape to close.
Click to select or double-click to apply. Images, animated GIFs, and muted looping
videos preview on the right. Closing while applying does not cancel `vpaper`.

The Linux profile enables `lurian.quickshell.enable` and
`lurian.quickshell.wallpaperPicker.enable`. The picker always includes
`~/wallpapers`; `wallpaperPicker.directories` adds recursive library roots.
The desktop profile adds `/mnt/Shared/Videos/Vpapers`. Missing roots are reported
in the picker. Nested directory symlinks are not followed. Libraries refresh on
open; the last query and selection are retained until the shell restarts.

Other options: `wallpaperPicker.keybind` (default `SUPER + V`) and
`wallpaperPicker.previewDelayMs` (default `120`).

## Lifecycle and theme

Home Manager manages `quickshell.service` under `hyprland-session.target`, using
the named `lurian` config. The launcher starts the service if needed, waits for
IPC, then toggles the picker. The QML controller outlives the window so applying
can finish after dismissal. A shell/service restart does terminate child jobs.

Matugen writes `~/.cache/matugen/quickshell-colors.json`. The theme watches this
file and keeps fallback/previous colors until a valid palette is available.
Configuration file autoreload is disabled to protect running apply jobs.
Home Manager restarts the service when deployed QML/settings change; activate
those changes when no apply is running.

GIFs now use the animated branch of `vpaper`. Select an old GIF wallpaper again
to install its animation; its extracted PNG is still used for theme generation.

## Checks and diagnostics

Pure helper checks (no Nix builds):

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s home-manager/quickshell/tests
node --test home-manager/quickshell/tests/fuzzy.test.cjs
```

After activating the configuration, check:

- Open on each monitor; search should be focused and the window centered.
- Rapidly cycle through images, GIFs, and videos; previews must stop on close.
- Apply GIF → image → video and verify looping, colors, and session persistence.
- Test a missing directory, corrupt file, and filenames with spaces/Unicode.
- Close during application, reopen, and verify only one apply is running.

```sh
systemctl --user status quickshell.service
journalctl --user -u quickshell.service -b
quickshell -c lurian ipc call wallpaperPicker ping
```
