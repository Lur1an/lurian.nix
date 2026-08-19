{
  config,
  pkgs,
  ...
}: let
  configHome = config.xdg.configHome;
  videoPath = "${configHome}/vpaper";
  wallpaperPath = "${configHome}/wallpaper.png";

  applyStaticWallpaper = pkgs.writeShellScript "apply-static-wallpaper" ''
    if [ ! -f "${videoPath}" ] && [ -f "${wallpaperPath}" ]; then
      ${pkgs.awww}/bin/awww img "${wallpaperPath}"
    fi
  '';

  waitForAwww = pkgs.writeShellScript "wait-for-awww" ''
    for _ in $(${pkgs.coreutils}/bin/seq 1 50); do
      if ${pkgs.awww}/bin/awww query >/dev/null 2>&1; then
        exec ${applyStaticWallpaper}
      fi
      ${pkgs.coreutils}/bin/sleep 0.1
    done

    echo "awww-daemon did not become ready" >&2
    exit 1
  '';

  runWallpaper = pkgs.writeShellScript "run-wallpaper" ''
    if [ -f "${videoPath}" ]; then
      exec ${pkgs.mpv}/bin/mpv --no-audio --panscan=1.0 --loop "${videoPath}"
    fi

    if [ -f "${wallpaperPath}" ]; then
      ${pkgs.awww}/bin/awww img "${wallpaperPath}"
    fi

    exec ${pkgs.coreutils}/bin/sleep infinity
  '';

  vpaper = pkgs.writeShellScriptBin "vpaper" ''
    set -uo pipefail

    if [ "$#" -lt 1 ]; then
      echo "Usage: vpaper <media-path> [matugen-type]" >&2
      exit 1
    fi

    INPUT=$(${pkgs.coreutils}/bin/realpath -- "$1") || exit 1
    MATUGEN_TYPE="''${2:-image}"
    VIDEO="${videoPath}"
    WALLPAPER="${wallpaperPath}"
    TMP_VIDEO=""
    TMP_WALLPAPER=""

    if [ ! -f "$INPUT" ] || [ ! -r "$INPUT" ]; then
      echo "vpaper: input is not a readable file: $INPUT" >&2
      exit 1
    fi

    ${pkgs.coreutils}/bin/mkdir -p "${configHome}"
    exec 9>"${configHome}/.vpaper.lock"
    ${pkgs.util-linux}/bin/flock 9

    cleanup() {
      [ -z "$TMP_VIDEO" ] || ${pkgs.coreutils}/bin/rm -f -- "$TMP_VIDEO"
      [ -z "$TMP_WALLPAPER" ] || ${pkgs.coreutils}/bin/rm -f -- "$TMP_WALLPAPER"
    }
    trap cleanup EXIT

    EXTENSION="''${INPUT##*.}"
    EXTENSION=$(printf '%s' "$EXTENSION" | ${pkgs.coreutils}/bin/tr '[:upper:]' '[:lower:]')

    case "$EXTENSION" in
      png|jpg|jpeg|webp|gif|bmp|tif|tiff|avif)
        TMP_WALLPAPER=$(${pkgs.coreutils}/bin/mktemp "${configHome}/.wallpaper.XXXXXX")
        if ! ${pkgs.ffmpeg}/bin/ffmpeg -loglevel error -i "$INPUT" -frames:v 1 -c:v png -f image2 -y "$TMP_WALLPAPER"; then
          echo "vpaper: failed to convert image: $INPUT" >&2
          exit 1
        fi

        if ! ${pkgs.coreutils}/bin/mv -f -- "$TMP_WALLPAPER" "$WALLPAPER"; then
          echo "vpaper: failed to install wallpaper image" >&2
          exit 1
        fi
        TMP_WALLPAPER=""
        if ! ${pkgs.coreutils}/bin/rm -f -- "$VIDEO"; then
          echo "vpaper: failed to disable the current video" >&2
          exit 1
        fi
        ;;
      *)
        TMP_VIDEO=$(${pkgs.coreutils}/bin/mktemp "${configHome}/.vpaper.XXXXXX")
        TMP_WALLPAPER=$(${pkgs.coreutils}/bin/mktemp "${configHome}/.wallpaper.XXXXXX")

        if ! ${pkgs.coreutils}/bin/cp --reflink=auto -- "$INPUT" "$TMP_VIDEO"; then
          echo "vpaper: failed to copy video: $INPUT" >&2
          exit 1
        fi
        if ! ${pkgs.ffmpeg}/bin/ffmpeg -loglevel error -i "$TMP_VIDEO" -frames:v 1 -c:v png -f image2 -y "$TMP_WALLPAPER"; then
          echo "vpaper: unsupported media or unable to extract a video frame: $INPUT" >&2
          exit 1
        fi

        if ! ${pkgs.coreutils}/bin/mv -f -- "$TMP_WALLPAPER" "$WALLPAPER"; then
          echo "vpaper: failed to install extracted video frame" >&2
          exit 1
        fi
        TMP_WALLPAPER=""
        if ! ${pkgs.coreutils}/bin/mv -f -- "$TMP_VIDEO" "$VIDEO"; then
          echo "vpaper: failed to install video" >&2
          exit 1
        fi
        TMP_VIDEO=""
        ;;
    esac

    if ${pkgs.matugen}/bin/matugen -j hex "$MATUGEN_TYPE" "$WALLPAPER"; then
      if ! ${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl reload; then
        echo "vpaper: warning: Hyprland reload failed" >&2
      fi
    else
      echo "vpaper: warning: matugen update failed" >&2
    fi
    ${pkgs.coreutils}/bin/rm -rf -- "$HOME/.cache/wal"
    if ! ${pkgs.pywal16}/bin/wal -i "$WALLPAPER" -n --cols16 lighten; then
      echo "vpaper: warning: pywal update failed" >&2
    fi
    if ! ${pkgs.pywalfox-native}/bin/pywalfox update; then
      echo "vpaper: warning: pywalfox update failed" >&2
    fi

    # wal's OSC 11 makes tmux paint opaque pane backgrounds; reset just tmux panes.
    if ${pkgs.tmux}/bin/tmux ls >/dev/null 2>&1; then
      for tty in $(${pkgs.tmux}/bin/tmux list-panes -a -F '#{pane_tty}'); do
        [ -w "$tty" ] && printf '\033]111\033\\' >"$tty" &
      done
    fi

    ${pkgs.systemd}/bin/systemctl --user restart vpaper.service
  '';
in {
  home.file."wallpapers".source = ../wallpapers;

  home.packages = [
    pkgs.awww
    vpaper
  ];

  systemd.user.services = {
    awww = {
      Unit = {
        Description = "Animated wallpaper daemon";
        PartOf = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        ExecStartPost = "${waitForAwww}";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = ["hyprland-session.target"];
    };

    vpaper = {
      Unit = {
        Description = "Video or static wallpaper";
        Requires = ["awww.service"];
        After = ["awww.service"];
        PartOf = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${runWallpaper}";
        Restart = "always";
        RestartSec = 1;
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
