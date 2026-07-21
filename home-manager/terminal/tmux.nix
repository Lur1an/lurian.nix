{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.tmuxConfig;

  color = c: "#{@${c}}";
  fg = color "white";

  # Window name, using pure tmux formats (no shell forks):
  #   opencode   -> its session title (from the pane title, "OC | " stripped)
  #   nvim / zsh -> project dir basename
  #   anything else -> #W
  window_name = let
    opencode_title = "#{=30:#{s/OC \\| //:pane_title}}";
    dir_name = "#{b:pane_current_path}";
    is_opencode = "#{==:#{pane_current_command},opencode}";
    is_shell_or_nvim = "#{m/r:^(nvim|zsh)$,#{pane_current_command}}";
  in "#{?${is_opencode},${opencode_title},#{?${is_shell_or_nvim},${dir_name},#W}}";

  indicator = let
    accent = color "indicator_color";
    content = "  ";
  in "#[reverse,fg=${accent}]#{?client_prefix,${content},}";

  current_window = let
    accent = color "main_accent";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=blue,bg=black] ${window_name} ";
  in "${index}${name}";

  window_status = let
    accent = color "window_color";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=red,bg=black] ${window_name}";
  in "${index}${name}";

  time = let
    accent = color "main_accent";
    format = "%H:%M";
    icon = pkgs.writeShellScript "clock-icon" ''
      icons=(󱑖 󱑋 󱑌 󱑍 󱑎 󱑏 󱑐 󱑑 󱑒 󱑓 󱑔 󱑕)
      printf '%s' "''${icons[$((10#$(date +%H) % 12))]}"
    '';
  in "#[fg=${accent}] ${format} #(${icon}) ";

  pwd = let
    accent = color "main_accent";
    icon = "#[fg=${accent}] ";
    format = "#[fg=${fg}]#{b:pane_current_path}";
  in "${icon}${format}";

  git = let
    branch = pkgs.writeShellScript "git-branch" ''
      branch=$(git -C "$1" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
      printf ' %s' "$branch"
    '';
  in "#[fg=magenta]#(${branch} '#{pane_current_path}')";

  separator = "#[fg=${fg}]|";

  sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    if [[ $# -eq 1 ]]; then
      selected=$1
    else
      selected=$(find ${lib.concatStringsSep " " cfg.projectDirs} -mindepth 1 -maxdepth 1 -type d 2>/dev/null | ${pkgs.fzf}/bin/fzf)
    fi

    [[ -z $selected ]] && exit 0

    name=$(basename "$selected" | tr '. ' '__')

    if ! ${pkgs.tmux}/bin/tmux has-session -t="$name" 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux new-session -ds "$name" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
      ${pkgs.tmux}/bin/tmux attach-session -t "$name"
    else
      ${pkgs.tmux}/bin/tmux switch-client -t "$name"
    fi
  '';
in {
  options.tmuxConfig = {
    projectDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["~/"];
      description = "Directories searched (one level deep) by the tmux sessionizer";
    };
  };

  config = {
    home.packages = [sessionizer];

    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        yank
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15'
          '';
        }
      ];
      terminal = "tmux-256color";
      prefix = "C-Space";
      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      mouse = false;
      historyLimit = 50000;
      extraConfig = ''
        set -as terminal-features ",*:RGB"
        set -g focus-events on
        set -g set-clipboard on
        set -g renumber-windows on
        set -g detach-on-destroy off
        set -g status-interval 5

        # Splits and new windows inherit the current path
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # Repeatable pane resizing (prefix, then tap H/J/K/L)
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        bind v copy-mode
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind-key b set-option status
        bind-key x kill-pane

        # Sessionizer: fuzzy-pick a project, get a session
        bind f display-popup -E -w 80% -h 60% "${sessionizer}/bin/tmux-sessionizer"

        # Scratch popup terminal (toggle with prefix+g)
        bind g if-shell -F '#{==:#{session_name},scratch}' \
          'detach-client' \
          'display-popup -E -w 80% -h 75% "tmux new-session -A -s scratch"'

        set-option -g @indicator_color "yellow"
        set-option -g @window_color "magenta"
        set-option -g @main_accent "blue"

        set-option -g status-right-length 100
        set-option -g pane-active-border fg=black
        set-option -g pane-border-style fg=black
        set-option -g status-style bg=black
        set-option -g status-left "${indicator}"
        set-option -g status-right "${git} ${pwd} ${separator} ${time}"
        set-option -g window-status-current-format "${current_window}"
        set-option -g window-status-format "${window_status}"
        set-option -g window-status-separator ""
      '';
    };
  };
}
