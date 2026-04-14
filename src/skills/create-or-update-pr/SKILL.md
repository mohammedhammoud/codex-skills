---
name: create-or-update-pr
description: Update the existing PR for the current branch when one exists, otherwise create a draft PR from git diff
argument-hint: "Optional: say if unstaged changes should be included"
---

Use for PR metadata create/update.
If current branch already has an open PR, update it. No duplicate PR.
- `git`: inspect branch/remote/default branch, create or switch branch, diff, push current branch
- `gh`: detect PR, read PR body, create draft PR, update title/body
Read `AGENTS.md` first. Repo commit/PR rules win.

Rules:
- No shell-script heuristics.
- Reason over raw diff.
- Keep output concise.

Workflow:
1. Detect current branch, relevant remote, default branch.
   - prefer upstream remote
   - else `origin` if safe
   - if no safe remote, stop
2. If current branch is default branch:
   - do not create or update PR yet
   - suggest branch name from dominant intent, short lowercase slug
   - default prefixes: `feat|fix|refactor|docs|chore|test|ci|perf/<slug>` unless repo says otherwise
   - check whether branch exists
   - if absent, ask whether to create and switch
   - if present, say so and ask whether to switch
   - only if next reply is exactly `yes`, create/switch, say committed changes are still required, then stop
   - otherwise stop
3. Pick diff source in this order:
   - committed: `git diff <remote>/<default-branch>...HEAD`
   - staged, if committed diff empty
   - unstaged, if staged diff empty
4. If all empty, stop and report no PR content yet.
5. State diff source used.
6. If user explicitly asked to include unstaged changes, allow that override and say so.
7. Generate metadata from selected raw diff.

Metadata:
- title: Conventional Commit style, lowercase, max 72 chars, unless repo says otherwise
- body must always use this exact block:
  <!-- auto-pr-metadata:start -->
  ## Changes
  - ...
  <!-- auto-pr-metadata:end -->
- inside block, allow only `## Changes`
- no `Summary`, `Testing`, or other sections
- default title regex unless repo says otherwise:
  `^(feat|fix|refactor|chore|docs|test|ci|perf)(\([a-z0-9._/-]+\))?: [a-z0-9][a-z0-9 -]{0,69}$`
- body must contain both markers exactly once
- body must contain `## Changes` with 3-8 bullets
- marker block is the only auto-generated content you may create or replace

Dry Run:
- print proposed title
- print full body, including markers
- then print exactly: `Type 'continue' to apply, anything else to cancel.`

Apply:
Apply only if next reply is exactly `continue`:
1. Re-check committed diff: `git diff <remote>/<default-branch>...HEAD`
2. If still empty, stop before push or `gh`.
   - say metadata came from staged or unstaged changes only
   - say changes must be committed first
3. If committed diff exists:
   - push branch first if needed
   - detect open PR for current branch, preferring one targeting default branch
   - update existing PR if found, else create draft PR targeting default branch

Existing PR:
If PR exists:
- keep current title if still accurate and valid
- update title only if outdated, inaccurate, or invalid
- update only marker block content when outdated, inaccurate, missing sections, or markers missing
- preserve all user text outside markers
- if markers missing, prepend block and keep existing body below
- if title and marker block already match diff, do not send update call

New PR:
If PR does not exist:
- create draft PR targeting default branch
- include marker block on first creation
- print PR URL and final title only
