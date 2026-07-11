{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      extended = true;
      ignoreAllDups = true;
      share = true;
    };

    sessionVariables = {
      CARGO_TERM_COLOR = "always";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      CLICOLOR_FORCE = "true";
      # NOTE: relative path, resolves against the CWD of whatever reads it
      OPENCODE_CONFIG = "../opencode.json";
    };

    shellAliases = {
      vim = "nvim";
      update = "find ~/.config -name '*hm-bak' -delete && find ~/.mozilla -name '*hm-bak' -delete && sudo nixos-rebuild switch --flake";
      gfw = "gh workflow view";
      gwt = "git worktree";
      dcd = "docker compose down";
      dcu = "docker compose up -d";
      vpn-on = "sudo wg-quick up ~/wg0.conf";
      vpn-off = "sudo wg-quick down ~/wg0.conf";
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initContent = ''
      ${builtins.readFile ./zsh-functions.sh}

      if [ -f ~/.impure_zsh ]; then
          source ~/.impure_zsh
      fi

      command -v uv &> /dev/null && eval "$(uv generate-shell-completion zsh)"

      # Enable system clipboard for zsh-vi-mode (uses wl-copy/wl-paste on Wayland)
      function zvm_config() {
        ZVM_SYSTEM_CLIPBOARD_ENABLED=true
      }

      # Re-source fzf keybindings after zsh-vi-mode init (zvm clobbers them)
      function zvm_after_init() {
        source ${config.programs.fzf.package}/share/fzf/completion.zsh
        source ${config.programs.fzf.package}/share/fzf/key-bindings.zsh
      }
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    fileWidgetOptions = ["--preview 'bat -n --color=always {}'"];
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = ["--preview 'eza --tree --level=2 --color=always {}'"];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = ["-p 80%,60%"];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
