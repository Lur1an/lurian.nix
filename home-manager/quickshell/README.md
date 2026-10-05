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

## Reusable forms

`quickshell-form form.json [CALLBACK ARG ...]` opens a themed floating form.
Without a callback it prints submitted values as JSON; cancellation exits 1.
With a callback it sends JSON values on stdin. Exit 0 closes the dialog;
nonzero exit displays stderr (or stdout) inline and allows a retry.
Commands execute in the caller's environment, not the Quickshell service's.

```json
{
  "title": "Example",
  "description": "Optional explanation",
  "submitLabel": "Apply",
  "fields": [
    {"id": "name", "label": "Name", "required": true},
    {"id": "mode", "label": "Mode", "type": "select", "options": ["One", "Two"]}
  ]
}
```

Text fields support `value`, `placeholder`, `pattern` (JavaScript regular
expression), and `validationMessage`. Select fields also support `value`.
Only one request is accepted at a time; another caller gets an error.

Escape, Cancel, and window-manager close cancel before submission is consumed.
Once the callback starts, closing only dismisses the UI; the callback completes.
The client exits if the service disappears. A 15-second heartbeat lease clears
abandoned requests if the client dies. Callbacks are never automatically retried.
