---
name: rebase
description: Rebase the current branch onto the default base branch by default, or onto an explicit target branch when provided, resolving only safe issues
argument-hint: "Optional: <target-branch> plus extra rebase constraints or conflict-handling preferences"
---

Use this skill when the user wants the current branch rebased without any push.

Target branch selection:

- Default behavior: use the repository default/base branch as the rebase target.
- Override: if the user explicitly provides a target branch, use that branch instead of the default/base branch.
- Treat only an explicit branch name as a target-branch override. If the input is ambiguous, stop and ask instead of guessing.
- If the explicit target branch matches the current branch, stop and ask.
- If the explicit target branch cannot be resolved safely, stop and ask.

Repository policy:

- Before applying this skill, read `AGENTS.md` (or equivalent repo-local instructions) if present.
- Repository-specific Git workflow and safety rules override this skill's generic defaults.
- If repository policy conflicts with the generic rules below, prefer repository policy and state the conflict briefly if needed.

Execution permissions:

- You may use `git` to:
  - detect the current branch, relevant remote, default branch, and explicit target branch when provided
  - inspect status, diff, rebase state, and relevant history
  - fetch the target branch
  - start `git rebase` and `git rebase --continue`
  - stage resolved files with path-scoped `git add`
- You may edit only conflicted files and the smallest fix scope needed to complete the rebase safely.
- You may run the smallest relevant local validation command when it materially reduces merge risk.

Start conditions:

- The current checkout must be a named non-default branch.
- The working tree must be clean before the rebase starts.
- If the current branch is the default branch, stop and ask what branch the user wants rebased.
- If `HEAD` is detached, stop and ask.
- If the working tree is dirty, stop and ask. Do not auto-stash and do not create a temporary commit.
- If the current branch tracks a remote branch, explain that rebasing rewrites local commit SHAs and may later require a force-push to update the remote branch. Because this skill must never push or force-push, ask the user whether to continue with a local-only rebase before starting.

High-risk refusal rule:

- If the rebase looks high risk to automate, refuse to start or continue it.
- State this clearly:
  - `Rebase refused: I do not consider this safe to perform automatically because <reason>. You need to do this rebase manually.`
- If the rebase is already in progress when that conclusion is reached, stop immediately and state instead that the user must finish or abort the rebase manually.
- High-risk examples include:
  - many conflicted files or conflicts spread across unrelated areas
  - semantic conflicts where code intent is unclear from the diff and history
  - conflicts involving large deletions, file moves plus edits, or rename/delete ambiguity
  - lockfile, generated-file, migration, schema, or binary conflicts where correctness is not obvious
  - repeated empty-commit or duplicate-change situations that suggest the branch history needs human judgment
  - validation failures after conflict resolution where the correct fix is not obvious

Workflow:

1. Determine the target branch.
   - If the user explicitly provided a target branch, use it.
   - Otherwise detect the relevant remote and the repository default/base branch.
   - Prefer the current branch upstream remote when available.
   - Otherwise prefer `origin` if it exists and fits the repository setup.
   - Prefer `<remote>/HEAD` for default branch detection when available.
   - If no safe target branch can be determined, stop and ask.
2. Refresh the target branch reference.
   - Prefer `git fetch <remote> <target-branch>` when a safe remote exists.
   - If fetch fails, is blocked, or no safe remote exists, ask whether to continue against the local target branch instead.
   - Do not silently fall back to a stale local branch.
3. Rebase the current branch onto the refreshed target-branch ref.
   - Prefer the explicit target-branch ref, not `git pull --rebase`.
4. If the rebase stops on conflicts or follow-up issues, inspect only the conflicted files and the minimum relevant history.
   - Use commit history and surrounding code to determine intent before editing.
   - Prefer manual, minimal merges over broad replacements.
5. After each safe resolution:
   - stage only the resolved file paths
   - run the smallest relevant validation command when useful
   - continue the rebase
6. If the rebase finishes cleanly, run the smallest relevant validation for the touched area when a meaningful command is available.
7. End with a concise status report and explicitly state that nothing was pushed.

Ask the user immediately when:

- the working tree is dirty
- the branch is detached, already on the default branch, or already on the chosen target branch
- the explicit target branch is ambiguous or cannot be resolved safely
- the remote or target branch cannot be determined safely
- fetching the target branch is unavailable and the local branch may be stale
- the branch already tracks a remote branch and the user has not approved a local-only history rewrite
- a conflict cannot be resolved confidently from the code and history
- the rebase produces an empty commit or suggests skipping a commit
- conflict resolution would require deleting a file, a large code region, or a lockfile entry without clear evidence
- validation fails and the minimal fix is not obvious
- the repository enters an unexpected rebase state

Guardrails:

- Never run `git push`.
- Never run `git push --force` or `git push --force-with-lease`.
- Never create or update a PR.
- Never auto-stash, never use `git rebase --autostash`, and never create a temporary "WIP" commit to make the rebase easier.
- Never use `git pull --rebase`.
- Never use interactive/history-shaping rebase modes such as `git rebase -i`, and never drop, squash, fixup, or reword commits unless the user explicitly asks for that.
- Never use `git rebase --skip` automatically.
- Never use `git rebase --abort` automatically unless the user explicitly asks for it.
- Never use destructive commands such as `git reset --hard`, `git clean`, or `git checkout --`.
- Never resolve a whole file by blindly taking `--ours` or `--theirs`.
- Never delete files, commits, or hunks just to make the rebase pass.
- Never stage unrelated files.
- Never rewrite anything beyond the current local branch history required by the requested rebase.
- If a next step could discard user work, hide history, or depends on a guess, stop and ask instead.
- If risk is high, refuse the rebase instead of trying to "push through" with another automatic fix.

Output:

- Keep output concise.
- Report:
  - target branch and ref used
  - whether the target came from default/base-branch detection or explicit user input
  - whether a fetch was used
  - rebase status
  - files changed during conflict resolution, if any
  - validation run, if any
  - any explicit blocker or question for the user
  - explicit refusal reason when the rebase is declined as too risky
  - confirmation that nothing was pushed
