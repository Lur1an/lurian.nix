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
      gfw = "gh workflow view";
      gcap = "git_commit_push_all";
      nvidia-offload = "nvidia_offload";
      quick-vnc = "quick_vnc";
      local-vnc = "remmina -c vnc://localhost:5900";
      kubecurl = "_kubecurl";
      kube-nuke = "kube_nuke";
      rust-dev = "rust_dev";
      boot-windows = "boot_windows";
      docker-debug = "docker_debug";
      seal = "kubeseal_encrypt";
      kubedel = "nuke_kubeconfig";
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
    initContent = ''
      function rust_dev() {
          local log_level=''${2:-info}
          RUST_LOG=$log_level cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
      }

      function _kubecurl() {
        kubectl run -n $1 curl-debug --image=curlimages/curl:latest --rm -it -- sh
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

      function nuke_kubeconfig() {
        kubectl config delete-cluster $1
        kubectl config delete-context $1
        kubectl config delete-user $1
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

      # -----------------------------------------------------------------------------
      # FUNCTION: kube_nuke
      # PURPOSE:  Forcefully removes all finalizers from every resource in a
      #           given Kubernetes namespace.
      # USAGE:    kube_nuke <namespace>
      # WARNING:  This is a destructive operation. It should only be used to clean
      #           up resources stuck in a 'Terminating' state.
      # -----------------------------------------------------------------------------
      function kube_nuke() {
        # Check if a namespace argument was provided
        if [ -z "$1" ]; then
          echo "ERROR: Namespace argument is required." >&2
          echo "Usage: kube_nuke <namespace>" >&2
          return 1
        fi

        local NS="$1"

        # --- FIX IS HERE ---
        # Confirmation prompt, written in a portable way for bash, zsh, etc.
        echo "WARNING: You are about to forcefully remove ALL finalizers from ALL resources in the '$NS' namespace."
        printf "This can lead to orphaned resources. Are you absolutely sure you want to proceed? Type 'yes' to continue: "
        read -r REPLY
        # --- END FIX ---

        # Using a more explicit check for the word "yes" for safety.
        if [[ "$REPLY" != "yes" ]]; then
          echo "Operation cancelled."
          return 1
        fi

        echo "Proceeding to patch all resources in namespace '$NS'..."

        # Find all namespaced resource types that can be listed and patched.
        # For each type, get all resource instances in the namespace and patch them.
        # Using a while read loop is often safer than xargs with complex commands.
        kubectl api-resources --verbs=list,patch --namespaced -o name | while read -r TYPE; do
          echo "INFO: Checking for resources of type '$TYPE'..."
          kubectl get "$TYPE" -n "$NS" -o name --ignore-not-found | \
            xargs -r -I {} kubectl patch {} -n "$NS" --type=merge -p '{"metadata":{"finalizers":[]}}'
        done

        echo "✅ Operation complete. All finalizers should have been removed from resources in '$NS'."
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

      PATH="$HOME/.npm-global/bin:$PATH"
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
