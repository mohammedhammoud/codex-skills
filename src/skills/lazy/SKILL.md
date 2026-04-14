---
name: lazy
description: Fully automate a user request from a fresh branch off the default branch through implementation, audit, safe refactor, commit, push, and draft PR, auto-iterating until the result is good enough or a real blocker is found
argument-hint: "Describe the task and constraints for end-to-end delivery"
---

Use for hands-off delivery.
Read `AGENTS.md` first. Repo workflow/validation/commit/PR rules win.

Wrapper Skills:

- `audit`
- `refactor`
- `commit`
- `create-or-update-pr`

Open those skills at runtime. Follow them. This skill overrides sequencing, automation, and blocker handling only. If one is unavailable, keep the contract below.

Workflow:

1. Understand request. Inspect only needed code.
2. Detect relevant remote and default branch.
   - prefer upstream remote
   - else `origin` if safe
   - prefer `<remote>/HEAD` for default branch detection
   - fall back to local default branch only if needed
   - if no safe remote for push or PR, stop and report blocker
3. Switch to default branch before new work.
   - if checkout is unsafe because of local changes, stop and report blocker
4. Create new feature branch from default branch.
   - use short lowercase kebab-case name from task
5. Implement change.
6. Run smallest relevant validation.
7. Apply `audit` standards to current diff.
   - if audit finds real issue, fix and audit again
8. Apply `refactor` standards only when clearly behavior-preserving and worth churn.
9. Re-run relevant validation after any fix or refactor.
10. Repeat implementation, audit, refactor, validation until good enough to ship or blocked.
11. Stage intended changes.
12. Apply `commit` standards and create commit.
13. Push branch.
14. Apply `create-or-update-pr` standards and create or update draft PR to default branch.

Interaction:

- Run automatically.
- Do not stop for `continue` prompts from `audit`, `refactor`, `commit`, or `create-or-update-pr` when result is safe and good enough.
- Treat satisfactory phase result as internal `continue`.
- If phase result is not good enough, iterate internally.
- Stop only for real blockers: unsafe checkout, missing required context, unresolved validation failure, push failure, or PR failure.

Guardrails:

- no unrelated edits
- no extra features
- do not weaken types, validation, or error handling
- do not skip audit
- do not force refactor when safest choice is no refactor
- do not create PR from default branch
- use one conventional commit message for final commit and PR title
- never use `--no-verify`
- keep PR body to auto-generated change block only

Output:

- branch name
- commit message
- validation run
- PR URL
