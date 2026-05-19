---
name: commit
description: Analyze staged git changes and create a well-crafted commit message, then commit. Use when user asks to commit, write a commit message, or mentions git commit.
---

# Commit

Create precise, well-formatted commit messages by analyzing staged changes, then commit.

## Workflow

### 1. Inspect staged changes

Run these commands in parallel:

- `git diff --cached --stat` — overview of files changed
- `git diff --cached` — full diff of all staged changes
- `git log --oneline -10` — recent commits for style consistency

If nothing is staged, tell the user and stop.

### 2. Analyze the diff

Read the full staged diff carefully. Identify:

- **What** changed: new files, modifications, deletions
- **Why** it changed: the intent behind the change (feature, fix, refactor, config update, etc.)
- **Scope**: which system/module/component is affected

### 3. Write the commit message

#### Subject line rules

- Lowercase, no trailing period
- Max 50 characters
- Use imperative mood: "add", "fix", "update", "remove", "refactor"
- Lead with the action verb
- Be specific: `add battery module` not `update config`
- No conventional commit prefixes (no `feat:`, `fix:`, etc.)
- No emojis

#### Body (only when needed)

Add a body separated by a blank line when:

- The "why" is not obvious from the subject
- Multiple logical changes are staged together
- There are subtle side effects worth noting

Body rules:

- Wrap at 72 characters
- Explain **why**, not what (the diff shows what)
- Use bullet points for multiple items

### 4. Commit

- Present the commit message to the user for approval
- Run `git commit -m "<message>"` (or `-m "<subject>" -m "<body>"` if body needed)
- If the commit fails (e.g. pre-commit hook), show the error and stop — the user will fix it

## Important

- Only commit what is already staged — never run `git add`
- Never amend existing commits
- Never push to remote
- Never skip hooks (no `--no-verify`)
- If the diff is enormous, summarize the key changes and ask the user if they want to split the commit
