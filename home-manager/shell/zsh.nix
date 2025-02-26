{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vim = "nvim";
      archaider = "aider --model deepseeklocal --architect";
      sgpt = "sgpt --model 'gpt-4'";
      update = "find ~/.config -name '*hm-bak' -delete && find ~/.mozilla -name '*hm-bak' -delete && sudo nixos-rebuild switch --flake";
      pydev = "watchfiles python -m src.main --dev";
      vpaper = "video_wallpaper";
      gcap = "git_commit_push_all";
      nvidia-offload = "nvidia_offload";
      quick-vnc = "quick_vnc";
      local-vnc = "remmina -c vnc://localhost:5900";
      rust-dev = "rust_dev";
      boot-windows = "boot_windows";
      docker-debug = "docker_debug";
      seal = "kubeseal_encrypt";
      make-thumb = "make_thumb";
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
    initExtra = ''
      function rust_dev() {
          local log_level=''${2:-info}
          RUST_LOG=$log_level cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
      }

      function nvidia_offload() {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      }

      function kubeseal_encrypt() {
        kubeseal --format yaml --scope $1 < $2 > $3
      }

      function boot_windows() {
          systemctl reboot --boot-loader-entry=auto-windows
      }

      function docker_debug() {
          docker exec -it $1 /bin/bash
      }

      function make_thumb() {
        ffmpeg -i $1 -vframes 1 $2
      }

      quick_vnc() {
          remmina -c "vnc://$1"
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
      export OLLAMA_API_BASE=http://127.0.0.1:11434
      export CLICOLOR_FORCE=true

      if [ -f ~/.secrets ]; then
          source ~/.secrets
      fi

      if [ -f ~/.fvm/env ]; then
        source ~/.fvm/env
      fi

      export AIDER_AUTO_COMMITS=false

      eval "$(direnv hook zsh)"
      eval "$(uv generate-shell-completion zsh)"
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
  };
}
