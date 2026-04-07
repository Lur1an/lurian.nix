---
name: prepare-release
description: Prepare a new release by updating CHANGELOG.md with categorized commit analysis, bumping version numbers, and documenting breaking changes with migration guides.
---

# Prepare Release

## Overview

Automate the preparation of a new release for a project. This includes determining the release version, analyzing commits, updating the changelog, and bumping version numbers in project manifests.

## Steps

### 1. Determine the release version

- If the user specifies a version, use it exactly.
- Otherwise, list all git tags with `git tag --sort=-v:refname` and find the highest semver tag.
- Increment the **minor** version by one and reset the patch to zero (e.g. `v1.3.2` becomes `v1.4.0`).
- If no tags exist at all, use `v0.1.0`.

### 2. Identify the commit range

- Find the latest git tag: `git describe --tags --abbrev=0`.
- Collect all commits from that tag to HEAD: `git log <latest-tag>..HEAD --oneline --no-merges`.
- If there are no prior tags, analyze all commits up to HEAD.

### 3. Analyze changes

The analysis happens in two passes. Both are required.

#### Pass 1: Per-commit diff analysis

For every commit in the range, read its **full diff** (`git show <sha> --stat` and `git show <sha> -- <file>` for files of interest). Do not rely on commit messages alone — a single commit can add, change, and remove things simultaneously. Record every individual change with its commit SHA for traceability.

#### Pass 2: Aggregate diff analysis

Generate the **overall diff** between the last tag and HEAD (`git diff <latest-tag>..HEAD`). Analyze this combined diff to understand the net effect of all commits together. This is critical because:

- A feature added in one commit may have been reverted or reworked in a later commit.
- Multiple incremental commits may together constitute a single logical change.
- A file deleted and re-added across commits results in a modification, not an addition.

Use the aggregate diff as the **source of truth** for what actually changed. Use the per-commit analysis to provide context, attribution, and to catch intent (e.g. a bug fix that touches the same lines as a feature addition).

#### Categorization

Classify the **net changes** into the following categories:

- **Added** - entirely new features or capabilities that did not exist at the last tag.
- **Changed** - behavior changes to existing features (non-breaking).
- **Deprecated** - features marked for future removal.
- **Removed** - features or capabilities that existed at the last tag and are now gone.
- **Fixed** - bug fixes.
- **Security** - vulnerability patches or security improvements.

Write a clear, human-readable summary for each item. Do not paste raw commit messages. Reference relevant commits where it aids understanding.

### 4. Detect breaking changes

Determine the project type by inspecting the repository:

#### Library projects (crates published to a registry, npm packages, shared libraries)

- Identify **BREAKING** changes: removed or renamed public API surface, changed function signatures, removed types, changed default behavior that consumers depend on.
- For each breaking change, write a **Migration Guide** section explaining exactly what changed and how downstream consumers should update their code. Include before/after code snippets where helpful.

#### Application projects that expose an API (REST, GraphQL, gRPC, CLI)

- Identify **BREAKING API** changes: removed endpoints, changed request/response schemas, renamed CLI flags or subcommands, changed exit codes.
- For each breaking API change, write a **Migration Guide** section explaining exactly what changed and how users or integrations should adapt. Include before/after examples where helpful.

#### Projects that are neither

- Skip the breaking changes section entirely.

### 5. Update CHANGELOG.md

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.
- If `CHANGELOG.md` does not exist, create it with the standard header.
- Insert a new section at the top (below the header) for the new version with today's date.
- Only include category subsections that have entries (omit empty ones).
- Place the **Breaking Changes** and **Migration Guide** subsections at the very top of the version section, before the other categories, so they are immediately visible.
- Preserve all existing changelog content below the new section.

### 6. Bump version in project manifests

Detect and update version strings in the following files if they exist:

| File | Field | Notes |
|------|-------|-------|
| `Cargo.toml` | `package.version` | Strip leading `v` from tag (e.g. `0.4.0` not `v0.4.0`) |
| `package.json` | `version` | Strip leading `v` |
| `pyproject.toml` | `project.version` or `tool.poetry.version` | Strip leading `v` |
| `version.txt` | entire content | Use tag as-is |

Only update files that already exist in the repository. Do not create new manifest files.

### 7. Summary

After completing all updates, present a summary to the user:

- The release version.
- Number of commits analyzed.
- List of files modified.
- Whether breaking changes were detected.
- Remind the user to review the changes before committing.

## Important

- Do NOT create a git tag or commit. Only prepare the files; the user decides when to commit and tag.
- Do NOT push anything to a remote.
- Ask the user for clarification if the versioning scheme is ambiguous (e.g. calver vs semver).
