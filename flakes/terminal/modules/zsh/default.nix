{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal.zsh;
  extraShell = lib.concatMapStringsSep "\n" builtins.readFile cfg.extraShellFiles;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.fd];
    programs.zsh = {
      enable = true;
      autocd = true;
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
      };
      shellAliases = {
        vim = "nvim";
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
        ${builtins.readFile ./functions.zsh}
        ${extraShell}

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        if [ -f ~/.impure_zsh ]; then source ~/.impure_zsh; fi
        command -v uv &> /dev/null && eval "$(uv generate-shell-completion zsh)"
        function zvm_config() { ZVM_SYSTEM_CLIPBOARD_ENABLED=true }
        function zvm_after_init() {
          source ${config.programs.fzf.package}/share/fzf/completion.zsh
          source ${config.programs.fzf.package}/share/fzf/key-bindings.zsh
          bindkey '^[[Z' autosuggest-accept
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
      fileWidget = {
        command = "fd --type f --hidden --exclude .git";
        options = ["--preview 'bat -n --color=always {}'"];
      };
      changeDirWidget = {
        command = "fd --type d --hidden --exclude .git";
        options = ["--preview 'eza --tree --level=2 --color=always {}'"];
      };
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = ["-p 80%,60%"];
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
