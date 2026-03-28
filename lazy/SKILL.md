---
name: lazy
description: Fully automate a user request from a fresh branch off the default branch through implementation, audit, safe refactor, commit, push, and draft PR, auto-iterating until the result is good enough or a real blocker is found
argument-hint: "Describe the task and constraints for end-to-end delivery"
---

Use this skill when the user wants a mostly hands-off delivery flow.

Repository policy:

- Before applying this skill, read `AGENTS.md` (or equivalent repo-local instructions) if present.
- Repository-specific workflow, validation, commit, and PR rules override this skill's generic defaults and any referenced sub-skill defaults.
- If repository policy conflicts with the generic rules below, prefer repository policy and state the conflict briefly if needed.

This is a wrapper skill. Use these repository skills as the baseline for quality and output rules:

- `audit`
- `refactor`
- `commit`
- `create-pull-request`

At runtime, open those skills and follow their instructions for the relevant phase.
This skill overrides only sequencing, automation, and blocker handling.
Keep this skill self-contained by treating the rules below as the minimum required contract even if one of the referenced skills is unavailable.

What this skill owns:

1. Branching
2. Automation
3. Iteration
4. Final reporting

Workflow:

1. Understand the request and inspect only the code needed.
2. Detect the relevant remote and the repository default branch.
   - Prefer the current branch upstream remote when available.
   - Otherwise prefer `origin` if it exists and fits the repository setup.
   - Prefer `<remote>/HEAD` for default branch detection when available.
   - Fallback to the local default branch if needed.
   - If no safe remote can be determined for push or PR work, stop and report the blocker.
3. Switch to the default branch before starting new work.
   - If checkout is unsafe because of local changes, stop and report the blocker.
4. Create a new feature branch from the default branch.
   - Use a short lowercase kebab-case branch name derived from the task.
5. Implement the requested change.
6. Run the smallest relevant validation for the touched area.
7. Apply the `audit` skill's standards to the current diff.
   - If the audit finds a real issue, fix it and audit again.
8. Apply the `refactor` skill's standards only if the refactor is clearly behavior-preserving and worth the churn.
   - If no worthwhile refactor exists, skip it.
9. Re-run relevant validation after any fix or refactor.
10. Repeat implementation, review, refactor, and validation until one of these is true:
   - the change is good enough to ship
   - a concrete blocker prevents safe progress
11. Stage the intended changes.
12. Apply the `commit` skill's standards and create the commit.
13. Push the branch to the relevant remote.
14. Apply the `create-pull-request` skill's standards and create or update a draft PR targeting the default branch.

Interaction override:

- This skill is intentionally automatic.
- Do not stop for the `continue` confirmations used by `audit`, `refactor`, `commit`, or `create-pull-request` when the result is good enough to proceed safely.
- Treat a satisfactory result in those phases as an internal automatic `continue`.
- If a phase is not good enough, iterate internally instead of asking the user to continue.
- Stop only for real blockers such as unsafe checkout, missing required context, failed validation you cannot resolve, push failure, or PR creation failure.

Guardrails:

- Do not edit unrelated files.
- Do not invent extra features beyond the request.
- Do not weaken types, validations, or error handling for convenience.
- Do not skip audit.
- Do not force a refactor when the safest choice is to keep the implementation as-is.
- Do not create a PR from the default branch.
- Use a single conventional commit message for the final commit and PR title.
- Never use `--no-verify` for commits.
- Keep the PR body limited to the auto-generated change summary block managed by the PR skill.

Final output:

- Be concise.
- Report:
  - branch name
  - commit message
  - validation run
  - PR URL
