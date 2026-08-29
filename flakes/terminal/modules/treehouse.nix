{inputs, ...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.lurian.terminal.treehouse;
    treehouse = inputs.treehouse.packages.${pkgs.stdenv.hostPlatform.system}.default;

    tmuxTreehouse = pkgs.writeShellApplication {
      name = "tmux-treehouse";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.git
        pkgs.gnugrep
        pkgs.jq
        pkgs.tmux
        treehouse
      ];
      text = ''
        repo=$(git rev-parse --show-toplevel 2>/dev/null) || {
          printf 'The current pane is not inside a Git repository.\n' >&2
          exit 1
        }

        printf 'Branch name: '
        IFS= read -r branch
        [[ -n $branch ]] || exit 0
        git check-ref-format --branch "$branch" >/dev/null

        repo_name=$(basename "$repo")
        repo_slug=$(printf '%s' "$repo_name" | tr -c '[:alnum:]_-' '_')
        branch_slug=$(printf '%.40s' "$branch" | tr -c '[:alnum:]_-' '_')
        common_dir=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir)
        IFS= read -r -d "" main_field < <(git -C "$repo" worktree list --porcelain -z)
        main_repo=''${main_field#worktree }
        session_hash=$(printf '%s\0%s' "$common_dir" "$branch" | sha256sum)
        session_hash=''${session_hash%% *}
        session_name="$repo_slug--$branch_slug--''${session_hash:0:10}"

        if tmux has-session -t "=$session_name" 2>/dev/null; then
          tmux switch-client -t "=$session_name"
          exit 0
        fi

        worktree=""
        candidate_path=""
        candidate_branch=""
        while IFS= read -r -d "" field; do
          case "$field" in
            "worktree "*) candidate_path="''${field#worktree }" ;;
            "branch "*) candidate_branch="''${field#branch }" ;;
            "")
              if [[ $candidate_branch == "refs/heads/$branch" ]]; then
                worktree=$candidate_path
                break
              fi
              candidate_path=""
              candidate_branch=""
              ;;
          esac
        done < <(git -C "$repo" worktree list --porcelain -z; printf '\0')

        cleanup_lease=false
        lease_id=""
        cleanup() {
          status=$?
          trap - EXIT INT TERM
          if [[ $cleanup_lease == true ]]; then
            treehouse return --force --if-lease-id "$lease_id" "$worktree" || true
          fi
          exit "$status"
        }
        trap cleanup EXIT INT TERM

        if [[ -z $worktree ]]; then
          if [[ -f $main_repo/treehouse.toml ]] && grep -Eq '^[[:space:]]*root[[:space:]]*=' "$main_repo/treehouse.toml"; then
            printf 'Remove the repo-level root from %s; lurian.terminal.treehouse.root controls worktree storage.\n' \
              "$main_repo/treehouse.toml" >&2
            exit 1
          fi

          allocation=$(cd "$main_repo" && treehouse get --lease --lease-holder "tmux:$session_name" --json)
          worktree=$(jq -r .path <<<"$allocation")
          lease_id=$(jq -r .lease_id <<<"$allocation")
          cleanup_lease=true

          if git -C "$repo" show-ref --verify --quiet "refs/heads/$branch"; then
            switch_args=(switch "$branch")
          elif git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
            switch_args=(switch --track -c "$branch" "origin/$branch")
          else
            switch_args=(switch -c "$branch")
          fi

          git -C "$worktree" "''${switch_args[@]}"
        fi

        tmux new-session -d -s "$session_name" -c "$worktree"
        cleanup_lease=false
        trap - EXIT INT TERM
        tmux switch-client -t "=$session_name"
      '';
    };
  in {
    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = lib.hasPrefix "/" cfg.root;
          message = "lurian.terminal.treehouse.root must be an absolute path";
        }
      ];

      home.packages = [
        treehouse
        tmuxTreehouse
      ];

      xdg.configFile."treehouse/config.toml".text = ''
        max_trees = ${toString cfg.maxTrees}
        root = "${cfg.root}"
      '';

      programs.tmux.extraConfig = lib.mkIf config.programs.tmux.enable ''
        # Prompt for a branch, lease its Treehouse worktree, and open its session.
        bind t display-popup -EE -d "#{pane_current_path}" -w 50% -h 7 "${tmuxTreehouse}/bin/tmux-treehouse"
      '';
    };
  };
}
