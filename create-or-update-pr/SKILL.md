---
name: create-or-update-pr
description: Update the existing PR for the current branch when one exists, otherwise create a draft PR from git diff
argument-hint: "Optional: say if unstaged changes should be included"
---

Execution permissions:

- You may use `git` to:
  - detect current branch
  - detect the relevant remote for the current branch
  - detect default branch
  - create and switch branches
  - compute diff
  - push the current branch to the relevant remote
- You may use `gh` CLI to:
  - detect existing PR for current branch
  - read PR body
  - create draft PR
  - update PR title and body

Use this skill when the user asks to create or update PR metadata.
If an open PR already exists for the current branch, update that PR.
Do not create a second PR for the same branch when an open one already exists.

Repository policy:

- Before applying this skill, read `AGENTS.md` (or equivalent repo-local instructions) if present.
- Repository-specific commit/PR conventions override this skill's generic defaults.
- If the repository defines additional allowed commit types, PR title rules, or release-related wording, follow the repository policy.
- If repository policy conflicts with the generic rules below, prefer repository policy and state the conflict briefly if needed.

Do not use shell scripts for metadata generation.
Do not invoke another AI CLI from inside any script.
Do not implement heuristics or pre-classification in bash.

Workflow:

1. Detect the current branch, the relevant remote, and the default branch.
   - Prefer the current branch upstream remote when available.
   - Otherwise prefer `origin` if it exists and fits the repository setup.
   - If no safe remote can be determined, stop and report the blocker.
2. If the current branch is the default branch, do not create or update a PR yet.
   - Suggest a branch name based on the dominant intent and a short lowercase slug if the current changes provide enough evidence.
   - Use the same default type vocabulary as Conventional Commits unless repository policy overrides it, for example:
     - `feat/<slug>`
     - `fix/<slug>`
     - `refactor/<slug>`
     - `docs/<slug>`
     - `chore/<slug>`
     - `test/<slug>`
     - `ci/<slug>`
     - `perf/<slug>`
   - Check whether the suggested branch already exists.
   - If it does not exist, ask whether the user wants you to create and switch to that branch.
   - If it already exists, say so explicitly and ask whether the user wants you to switch to that branch instead.
   - Only if the user's next reply is exactly `yes`, create and switch to the suggested branch, or switch to the existing branch when applicable.
   - After creating or switching branches, state clearly that the user still needs committed changes on that branch before a PR can be created or updated.
   - After that message, stop. Do not continue into diff generation, push, or PR creation in the same turn.
   - Otherwise, stop.
3. Determine the best available diff source in this order:
   - committed diff: `git diff <remote>/<default-branch>...HEAD`
   - staged diff, if the committed diff is empty
   - unstaged diff, if staged diff is empty
4. If all diff sources are empty, stop and report that there is no PR content to generate yet.
5. State explicitly which diff source is being used.
6. If the user explicitly asks to include unstaged changes, allow that override and state it explicitly.
7. Reason directly over raw diff content from the selected source.
8. Generate candidate metadata:

- title: Conventional Commit style, lowercase, max 72 chars, unless the repository defines a different allowed convention
- body: MUST always be wrapped in this exact marker block (even when creating a new PR):

  <!-- auto-pr-metadata:start -->

  ## Changes
  - ...
  <!-- auto-pr-metadata:end -->

- Inside the marker block, ONLY these sections are allowed:
  - `## Changes`
- No other sections allowed (no `Summary`, no `Testing`).

9. Validate before applying:

- title must match this regex by default, unless repository policy defines a different valid convention:
  `^(feat|fix|refactor|chore|docs|test|ci|perf)(\([a-z0-9._/-]+\))?: [a-z0-9][a-z0-9 -]{0,69}$`
- body MUST contain BOTH markers exactly once:
  - `<!-- auto-pr-metadata:start -->`
  - `<!-- auto-pr-metadata:end -->`
- body must contain:
  - `## Changes` with 3–8 bullets
- The marker block must be the ONLY auto-generated content you create/overwrite.

10. Dry-run output first:

- Print the proposed title and the full body (including markers).
- Then print exactly:
  `Type 'continue' to apply, anything else to cancel.`

11. Only if the user's next reply is exactly `continue`:

- Re-check whether there is a committed diff: `git diff <remote>/<default-branch>...HEAD`
- If that committed diff is still empty, stop before any push or `gh` call.
- In that case, report that PR metadata was generated from staged or unstaged changes only, and that the changes must be committed first before a PR can be created or updated.
- Only if a committed diff exists:
  - If the current branch has not been pushed yet, push it to the relevant remote before opening or updating the PR.

- Detect whether an open PR exists for the current branch (prefer PR targeting the default branch).
- If one exists, update that PR instead of creating another PR.

If PR exists:

- This is the default path whenever an open PR already exists for the current branch.
- First evaluate whether the current PR title and current marker block still accurately reflect the current diff.
- If they are still accurate, keep them as-is, even when wording differs from newly generated candidate metadata.
- Update the PR title ONLY when the current title is outdated, inaccurate, or invalid by repository/title rules.
- Update ONLY the content inside the markers when the current marker content is outdated, inaccurate, missing required sections, or markers are missing:
  - `<!-- auto-pr-metadata:start -->`
  - `<!-- auto-pr-metadata:end -->`
- Inside the marker block, edits may add, remove, or rewrite bullets as needed to match the current diff.
- Preserve all user-authored text outside the markers.
- If markers do not exist yet in the PR body, prepend the marker block at the top and keep the existing body below it unchanged.
- When both title and marker block are already accurate for the current diff, do not send an update call.

If PR does not exist:

- Create a DRAFT PR targeting the default branch.
- The PR body MUST include the marker block on first creation (do not omit markers).

Output behavior:

- Keep output concise.
- When done, print PR URL and final title only.
