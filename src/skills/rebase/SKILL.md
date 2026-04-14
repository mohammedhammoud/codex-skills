---
name: rebase
description: Rebase the current branch onto the default base branch by default, or onto an explicit target branch when provided, resolving only safe issues
argument-hint: "Optional: <target-branch> plus extra rebase constraints or conflict-handling preferences"
---

Use for local rebase only. Never push.

Target:
- default: repo default/base branch
- override only when user gives explicit branch name
- if override is ambiguous, same as current branch, or cannot be resolved safely, stop and ask
Read `AGENTS.md` first. Repo Git/safety rules win.

Allowed:
- `git` to inspect branch, remote, base branch, status, diff, rebase state, history; fetch target; run `git rebase` and `git rebase --continue`; stage resolved files with path-scoped `git add`
- edit only conflicted files and smallest safe scope
- run smallest relevant validation when it meaningfully reduces merge risk

Start:
- current checkout must be named non-default branch
- working tree must be clean
- if on default branch, detached `HEAD`, or dirty tree, stop and ask
- do not auto-stash and do not create temp commits
- if branch tracks remote, explain that rebasing rewrites local SHAs and may later require force-push; since this skill never pushes, ask before local-only rebase

Refuse:
- refuse if automation looks unsafe
- say exactly: `Rebase refused: I do not consider this safe to perform automatically because <reason>. You need to do this rebase manually.`
- if rebase already in progress when risk becomes too high, stop and say user must finish or abort manually
- many conflicted files or unrelated conflict areas
- semantic conflicts with unclear intent
- large deletions, file moves plus edits, rename/delete ambiguity
- lockfile, generated-file, migration, schema, or binary conflicts with unclear correctness
- repeated empty-commit or duplicate-change situations that need human judgment
- validation failures where correct fix is unclear

Workflow:
1. Determine target branch.
   - use explicit user branch if given
   - else detect safe remote and default/base branch
   - prefer upstream remote, else `origin` if safe
   - prefer `<remote>/HEAD` for default branch detection
   - if no safe target, stop and ask
2. Refresh target ref.
   - prefer `git fetch <remote> <target-branch>` when safe
   - if fetch fails, is blocked, or no safe remote exists, ask whether to continue against local target branch
   - do not silently use stale local branch
3. Rebase current branch onto refreshed target ref.
   - prefer explicit target ref
   - never use `git pull --rebase`
4. If rebase stops, inspect only conflicted files and minimum relevant history.
   - use history and surrounding code to infer intent
   - prefer manual minimal merges
5. After each safe resolution:
   - stage only resolved paths
   - run smallest useful validation when helpful
   - continue rebase
6. If rebase finishes cleanly, run smallest relevant validation for touched area when meaningful.
7. End with concise status. State that nothing was pushed.

Ask:
- tree dirty
- detached `HEAD`, on default branch, or already on target branch
- explicit target ambiguous or unsafe
- remote or target cannot be determined safely
- fetch unavailable and local target may be stale
- branch tracks remote and user has not approved local-only history rewrite
- conflict cannot be resolved confidently
- rebase suggests empty commit or skip
- resolution would require deleting file, large code region, or lockfile entry without clear evidence
- validation fails and minimal fix is unclear
- repo enters unexpected rebase state

Guardrails:
- never run `git push`
- never run `git push --force` or `git push --force-with-lease`
- never create or update PR
- never auto-stash, `git rebase --autostash`, or temp WIP commit
- never use `git pull --rebase`
- never use interactive/history-shaping modes: `git rebase -i`, drop, squash, fixup, reword unless user explicitly asks
- never use `git rebase --skip` automatically
- never use `git rebase --abort` automatically unless user explicitly asks
- never use destructive commands like `git reset --hard`, `git clean`, `git checkout --`
- never blindly resolve whole file with `--ours` or `--theirs`
- never delete files, commits, or hunks just to finish rebase
- never stage unrelated files
- never rewrite beyond current local branch history needed for requested rebase
- if next step could discard work, hide history, or depends on guess, stop and ask
- if risk is high, refuse

Output:
- target branch and ref used
- whether target came from default/base detection or explicit user input
- whether fetch was used
- rebase status
- files changed during conflict resolution, if any
- validation run, if any
- blocker or question, if any
- explicit refusal reason, if refused
- confirmation that nothing was pushed
