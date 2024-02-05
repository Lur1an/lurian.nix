{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      sgpt = "sgpt --model 'gpt-4'";
      update = "sudo nixos-rebuild switch --flake";
      protonvpn-de = "sudo openvpn --config ~/de.protonvpn.net.udp.ovpn --auth-user-pass ~/proton-credentials";
      protonvpn-it = "sudo openvpn --config ~/it.protonvpn.net.udp.ovpn --auth-user-pass ~/proton-credentials";
      copilot = "gh copilot suggest";
      ezpush = "aicommits --all && git push";
    };
    initExtra = ''
      function rust_dev() {
          RUST_LOG=info cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
      }

      function boot_windows() {
          systemctl reboot --boot-loader-entry=auto-windows
      }

      alias rust-dev='rust_dev'
      alias boot-windows='boot_windows'

      export CARGO_TERM_COLOR=always
      export CLICOLOR_FORCE=true

      if [ -f ~/.secrets ]; then
          source ~/.secrets
      fi

      eval "$(direnv hook zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "poetry"];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings =
      {
        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "starship";
          rev = "HEAD";
          sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
        }
        + /palettes/mocha.toml));
  };
}
