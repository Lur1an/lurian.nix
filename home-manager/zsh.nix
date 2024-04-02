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
      vim = "nvim";
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

      function nvidia_offload() {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      }

      function boot_windows() {
          systemctl reboot --boot-loader-entry=auto-windows
      }

      function docker_debug() {
          docker exec -it $1 /bin/bash
      }

      function video_wallpaper() {
        killall -9 mpv
        nohup mpv --no-audio --loop "$1" >/dev/null 2>&1 &
      }

      function git_commit_push_all() {
        git add -A
        git commit -m $1
        git push
      }

      alias vpaper='video_wallpaper'

      alias gcap='git_commit_push_all'
      alias nvidia-offload='nvidia_offload'
      alias rust-dev='rust_dev'
      alias boot-windows='boot_windows'
      alias docker-debug='docker_debug'

      export CARGO_TERM_COLOR=always
      export CLICOLOR_FORCE=true

      if [ -f ~/.secrets ]; then
          source ~/.secrets
      fi

      if [ -f ~/.fvm/env ]; then
        source ~/.fvm/env
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
