{
  pkgs,
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
      pydev = "watchfiles python -m src.main --dev";
      vpaper = "video_wallpaper";
      gcap = "git_commit_push_all";
      nvidia-offload = "nvidia_offload";
      rust-dev = "rust_dev";
      boot-windows = "boot_windows";
      docker-debug = "docker_debug";
    };
    initExtra = ''
      function rust_dev() {
          RUST_LOG=debug cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
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
          sha256 = "sha256-KzXO4dqpufxTew064ZLp3zKIXBwbF8Bi+I0Xa63j/lI=";
        }
        + /palettes/mocha.toml));
  };
}
