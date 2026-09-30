---
name: Treehouse
description: Always use when the user requests a worktree, working in a worktree, or Treehouse. Allocate and enter with Treehouse, do the task inside the worktree, and return it when finished.
---

# Treehouse

Treehouse manages a reusable pool of Git worktrees. Use it for worktree
allocation and cleanup instead of `git worktree add/remove`.

## Allocate and enter

1. Record the original working directory and intended base commit/branch.
   Run `treehouse status` from the repository to inspect its pool.
2. For a new task, reserve a worktree non-interactively:
   ```sh
   treehouse get --lease --lease-holder "agent:<session-id>" --json
   ```
   Save the returned `path` and `lease_id` for cleanup. A lease keeps the slot
   reserved between tool calls, even when no process is running there.
3. Find its slot name in `treehouse status`, then enter using:
   ```sh
   treehouse enter --print-path <name>
   ```
   Use the printed absolute path as the working directory for all task tools.
   In OpenCode, move the session there with `opencode.session_move`.
   A shell tool's `cd` does not persist across calls. For an interactive terminal,
   `treehouse enter <name>` opens a subshell instead.
4. In the worktree, create a task branch from the intended base with
   `git switch -c <task-branch> <base>`, or switch to the requested existing
   branch. Read its local instructions; perform all edits and checks there.

For a specifically requested existing worktree, use `status` and `enter`
directly. Entering does not allocate, reset, lease, or automatically return a
slot; it can also attach to an in-use slot. Keep track of who owns its lease.

## Finish and return

1. Finish validation and preserve the result outside the reusable checkout:
   commit to the task branch when authorized, or transfer the changes (including
   untracked files) to the intended destination and verify them there.
2. Once the result is preserved and `git status --short` is clean, run
   `git switch --detach` in the worktree so resetting the slot cannot move the
   task branch. Stop task-owned background processes.
3. Move the session and tool working directory back to the original directory,
   then release the allocation:
   ```sh
   treehouse return --if-lease-id "<saved-lease-id>" "<worktree-path>"
   ```
   For an unleased slot you own, use `treehouse return "<worktree-path>"`.
   Return resets the checkout and terminates lingering processes; do not use
   `--force` to discard unfinished work or return another task's lease.
4. Check `treehouse status` and report where the result was preserved and
   whether return succeeded. If preservation or return fails, report the blocker
   and retained path/lease rather than claiming cleanup completed.
