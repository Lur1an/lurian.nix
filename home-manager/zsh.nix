{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake"; 
    };
    initExtra = ''
      alias ezpush='aicommits --all && git push'
      function rust_dev() {
          RUST_LOG=info cargo-watch -x check -x "test $1 -- --nocapture"
      }

      function boot_windows() {
          systemctl reboot --boot-loader-entry=auto-windows
      }
      alias rust-dev='rust_dev'
      alias boot-windows='boot_windows'
      export CARGO_TERM_COLOR=always
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "poetry" ];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
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