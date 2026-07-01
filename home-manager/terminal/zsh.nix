{pkgs, ...}: let
  fzf = pkgs.fzf;
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
      function rust-dev() {
          local log_level=''${2:-info}
          RUST_LOG=$log_level cargo watch -x check -x "nextest run --workspace --no-capture -E 'test($1)'"
      }

      function kubecurl() {
        kubectl run -n $1 curl-debug --image=curlimages/curl:latest --rm -it -- sh
      }

      # Merge one kubeconfig into another with yq.
      # Entries in clusters/users/contexts are matched by their `name` field:
      # a matching name is merged & replaced, anything else is appended.
      # Usage: kubemerge <source> [dest]   (dest defaults to $KUBECONFIG or ~/.kube/config)
      function kubemerge() {
        local new="$1"
        local dest="''${2:-''${KUBECONFIG%%:*}}"
        dest="''${dest:-$HOME/.kube/config}"

        if [ -z "$new" ] || [ ! -f "$new" ]; then
          echo "Usage: kubemerge <source-kubeconfig> [dest-kubeconfig]"
          echo "Merges <source> into <dest> (default: \$KUBECONFIG or ~/.kube/config),"
          echo "matching clusters/users/contexts by name (merge & replace, else append)."
          return 1
        fi

        mkdir -p "$(dirname "$dest")"

        # Nothing to merge into yet: just seed the destination.
        if [ ! -f "$dest" ]; then
          cp "$new" "$dest"
          echo "Created $dest from $new"
          return 0
        fi

        cp "$dest" "$dest.bak"
        local tmp
        tmp="$(mktemp)"

        if yq eval-all '
          select(fileIndex == 0) as $dst | select(fileIndex == 1) as $new
          | ($dst * $new)
          | .current-context = ((($dst."current-context" // "") | select(. != "")) // $new."current-context")
          | .clusters = ((($dst.clusters // []) + ($new.clusters // [])) | (.[] | {.name: .}) as $i ireduce ({}; . * $i) | [.[]])
          | .users    = ((($dst.users // [])    + ($new.users // []))    | (.[] | {.name: .}) as $i ireduce ({}; . * $i) | [.[]])
          | .contexts = ((($dst.contexts // []) + ($new.contexts // [])) | (.[] | {.name: .}) as $i ireduce ({}; . * $i) | [.[]])
        ' "$dest.bak" "$new" > "$tmp"; then
          mv "$tmp" "$dest"
          echo "Merged $new into $dest (backup at $dest.bak)"
        else
          rm -f "$tmp"
          echo "kubemerge failed; $dest left unchanged (backup at $dest.bak)"
          return 1
        fi
      }

      function nvidia-offload() {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      }

      function boot-windows() {
          systemctl reboot --boot-loader-entry=auto-windows
      }

      function docker-debug() {
          docker exec -it $1 /bin/bash
      }

      function make-thumb() {
        ffmpeg -i $1 -vframes 1 $2
      }

      quick-vnc() {
          remmina -c "vnc://$1"
      }

      function gcap() {
        git add -A
        git commit -m $1
        git push
      }

      function ot() {
          local branch="$1"

          if [ -z "$branch" ]; then
              echo "Usage: ot <branch-name>"
              return 1
          fi

          # 1. Prune dangling worktrees first
          git worktree prune

          # Get repo name to ensure unique path in /tmp (e.g., /tmp/my-project/feature-x)
          local repo_root
          repo_root=$(git rev-parse --show-toplevel)
          local repo_name
          repo_name=$(basename "$repo_root")
          local target_dir="/tmp/''${repo_name}/''${branch}"

          # Safety: If the folder exists in /tmp but isn't a valid worktree (prune didn't catch it),
          # remove it to allow the new worktree to be created.
          if [ -d "$target_dir" ]; then
              rm -rf "$target_dir"
          fi

          echo "Setting up worktree in: $target_dir"

          # 2. Create the worktree
          # Attempt 1: Try to checkout an existing local or remote branch
          if ! git worktree add "$target_dir" "$branch" 2>/dev/null; then
              echo "Branch '$branch' does not exist. Creating it..."
              # Attempt 2: Create a new branch (-b) based on current HEAD
              git worktree add -b "$branch" "$target_dir"
          fi

          # 3. Go into directory
          cd "$target_dir"

          direnv allow || true

          # 4. Open Opencode
          opencode .
      }

      export CARGO_TERM_COLOR=always
      export OLLAMA_API_BASE=http://127.0.0.1:11434
      export CLICOLOR_FORCE=true
      export OPENCODE_CONFIG=../opencode.json

      if [ -f ~/.impure_zsh ]; then
          source ~/.impure_zsh
      fi

      eval "$(direnv hook zsh)"
      command -v uv &> /dev/null && eval "$(uv generate-shell-completion zsh)"

      # Enable system clipboard for zsh-vi-mode (uses wl-copy/wl-paste on Wayland)
      function zvm_config() {
        ZVM_SYSTEM_CLIPBOARD_ENABLED=true
      }

      # Re-source fzf keybindings after zsh-vi-mode init (zvm clobbers them)
      function zvm_after_init() {
        source ${fzf}/share/fzf/completion.zsh
        source ${fzf}/share/fzf/key-bindings.zsh
      }
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
