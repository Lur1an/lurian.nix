{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vim = "nvim";
      update = "find ~/.config -name '*hm-bak' -delete && find ~/.mozilla -name '*hm-bak' -delete && sudo nixos-rebuild switch --flake";
      gfw = "gh workflow view";
      gcap = "git_commit_push_all";
      nvidia-offload = "nvidia_offload";
      dcd = "docker compose down";
      dcu = "docker compose up -d";
      rust-dev = "rust_dev";
      boot-windows = "boot_windows";
      docker-debug = "docker_debug";
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
      function rust_dev() {
          local log_level=''${2:-info}
          RUST_LOG=$log_level cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
      }

      function kubecurl() {
        kubectl run -n $1 curl-debug --image=curlimages/curl:latest --rm -it -- sh
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

      function make_thumb() {
        ffmpeg -i $1 -vframes 1 $2
      }

      quick_vnc() {
          remmina -c "vnc://$1"
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

      eval "$(direnv hook zsh)"
      eval "$(uv generate-shell-completion zsh)"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
