# hyprwinwrap

Clone of xwinwrap for hyprland.

Example config:
```lua
hl.config({
    plugin = {
        hyprwinwrap = {
            -- Class and title are exact matches, not regular expressions.
            class = "kitty-bg",
            title = "kitty-bg",
            -- Position and size are percentages.
            pos_x = "25",
            pos_y = "30",
            size_x = "40",
            size_y = "70",
        },
    },
})
```

Launch `kitty -c "~/.config/hypr/kittyconfigbg.conf" --class="kitty-bg" "/home/vaxry/.config/hypr/cava.sh"`

Example script for cava:

```sh
#!/bin/sh
sleep 1 && cava
```

_sleep required because resizing happens a few ms after open, which breaks cava_
