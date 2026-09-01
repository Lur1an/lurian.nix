{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal.tmux;
  tmuxBin = "${pkgs.tmux}/bin/tmux";

  mkTmuxScript = name: body:
    pkgs.writeShellScript name ''
      tmux() {
        ${tmuxBin} "$@"
      }
      ${body}
    '';
  mkTmuxScriptBin = name: body:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [pkgs.tmux pkgs.coreutils pkgs.findutils pkgs.git pkgs.fzf];
      text = body;
    };

  # Status formats
  color = c: "#{@${c}}";
  fg = color "white";

  # Window name, using pure tmux formats (no shell forks):
  #   opencode   -> its session title (from the pane title, "OC | " stripped)
  #   nvim / zsh -> project dir basename
  #   anything else -> #W
  windowName = let
    opencodeTitle = "#{=30:#{s/OC \\| //:pane_title}}";
    dirName = "#{b:pane_current_path}";
    isOpencode = "#{==:#{pane_current_command},opencode}";
    isShellOrNvim = "#{m/r:^(nvim|zsh)$,#{pane_current_command}}";
  in "#{?${isOpencode},${opencodeTitle},#{?${isShellOrNvim},${dirName},#W}}";

  indicator = let
    accent = color "indicator_color";
    content = "  ";
  in "#[reverse,fg=${accent}]#{?client_prefix,${content},}";

  currentWindow = let
    accent = color "main_accent";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=blue,bg=black] ${windowName} ";
  in "${index}${name}";

  windowStatus = let
    accent = color "window_color";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=red,bg=black] ${windowName}";
  in "${index}${name}";

  statusTime = let
    accent = color "main_accent";
    format = "%H:%M";
    icon = pkgs.writeShellScript "clock-icon" ''
      icons=(󱑖 󱑋 󱑌 󱑍 󱑎 󱑏 󱑐 󱑑 󱑒 󱑓 󱑔 󱑕)
      printf '%s' "''${icons[$((10#$(${pkgs.coreutils}/bin/date +%H) % 12))]}"
    '';
  in "#[fg=${accent}] ${format} #(${icon}) ";

  statusPath = let
    accent = color "main_accent";
    icon = "#[fg=${accent}] ";
    format = "#[fg=${fg}]#{b:pane_current_path}";
  in "${icon}${format}";

  statusGit = let
    branch = pkgs.writeShellScript "git-branch" ''
      branch=$(${pkgs.git}/bin/git -C "$1" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
      printf ' %s' "$branch"
    '';
  in "#[fg=magenta]#(${branch} '#{pane_current_path}')";

  separator = "#[fg=${fg}]|";

  # tmux actions
  sessionizer = mkTmuxScriptBin "tmux-sessionizer" ''
    if [[ $# -eq 1 ]]; then
      selected=$1
    else
      selected=$(
        # shellcheck disable=SC2088
        roots=(${lib.concatMapStringsSep " " lib.escapeShellArg cfg.projectDirs})
        for root in "''${roots[@]}"; do
          root="''${root/#\~/$HOME}"
          if [[ -e "$root/.git" ]]; then
            printf '%s\n' "$root"
          else
            find "$root" -mindepth 1 -maxdepth 3 -type d \
              \( -exec ${pkgs.coreutils}/bin/test -e '{}/.git' \; -print -prune -o -print \)
          fi
        done 2>/dev/null | ${pkgs.fzf}/bin/fzf
      )
    fi

    [[ -z $selected ]] && exit 0

    name=$(basename "$selected" | tr '. ' '__')

    if ! tmux has-session -t="$name" 2>/dev/null; then
      tmux new-session -ds "$name" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
      tmux attach-session -t "$name"
    else
      tmux switch-client -t "$name"
    fi
  '';

  joinWindow = mkTmuxScript "tmux-join-window" ''
    target_pane=$1
    source_index=$2
    target_window=$(tmux display-message -p -t "$target_pane" '#{window_index}')
    target_session=$(tmux display-message -p -t "$target_pane" '#{session_name}')

    [[ -z $source_index ]] && exit 0
    if ! [[ $source_index =~ ^[0-9]+$ ]]; then
      tmux display-message "Enter a window number"
      exit 1
    fi
    if [[ $source_index == "$target_window" ]]; then
      tmux display-message "Cannot join a window to itself"
      exit 1
    fi

    source_target="$target_session:$source_index"
    source_panes=$(tmux display-message -p -t "$source_target" '#{window_panes}' 2>/dev/null) || {
      tmux display-message "Window $source_index does not exist"
      exit 1
    }
    if [[ $source_panes != 1 ]]; then
      tmux display-message "Window $source_index has $source_panes panes"
      exit 1
    fi

    source_pane=$(tmux list-panes -t "$source_target" -F '#{pane_id}')

    tmux set-option -p -t "$source_pane" @split_origin_index "$source_index"
    tmux join-pane -h -s "$source_pane" -t "$target_pane"
  '';

  restoreWindow = mkTmuxScript "tmux-restore-window" ''
    pane=$1
    origin_index=$(tmux show-options -p -v -t "$pane" @split_origin_index 2>/dev/null) || true
    session=$(tmux display-message -p -t "$pane" '#{session_name}')
    indexes=($(tmux list-windows -t "$session:" -F '#{window_index}'))
    highest_index=0

    for index in "''${indexes[@]}"; do
      (( index > highest_index )) && highest_index=$index
    done

    if [[ -z $origin_index ]]; then
      tmux break-pane -d -s "$pane" -t "$session:$((highest_index + 1))"
      exit 0
    fi

    occupied=false
    for index in "''${indexes[@]}"; do
      [[ $index == "$origin_index" ]] && occupied=true
    done

    if $occupied; then
      tmux set-option -t "$session" renumber-windows off

      for ((index = highest_index; index >= origin_index; index--)); do
        if ! tmux move-window -d -s "$session:$index" -t "$session:$((index + 1))"; then
          tmux set-option -tu -t "$session" renumber-windows
          tmux display-message "Could not restore window $origin_index"
          exit 1
        fi
      done

      if ! tmux break-pane -d -s "$pane" -t "$session:$origin_index"; then
        tmux set-option -tu -t "$session" renumber-windows
        tmux display-message "Could not restore window $origin_index"
        exit 1
      fi
      tmux set-option -tu -t "$session" renumber-windows
    else
      tmux break-pane -d -s "$pane" -t "$session:$origin_index"
    fi

    tmux set-option -up -t "$pane" @split_origin_index
  '';
in {
  config = lib.mkIf cfg.enable {
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

        # Join a single-pane window beside this pane, or restore it at its original index.
        bind j command-prompt -p "Join window index:" "run-shell '${joinWindow} #{pane_id} %1'"
        bind u run-shell "${restoreWindow} '#{pane_id}'"

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
        set-option -g status-right "${statusGit} ${statusPath} ${separator} ${statusTime}"
        set-option -g window-status-current-format "${currentWindow}"
        set-option -g window-status-format "${windowStatus}"
        set-option -g window-status-separator ""
      '';
    };
  };
}
