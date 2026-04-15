---
name: commit
description: Generate and optionally apply a Conventional Commit from staged changes
argument-hint: "Stage changes first, then run without extra arguments"
---

Generate one best Conventional Commit from staged changes.

Workflow:
Run `git diff --cached --stat`. Run `git diff --cached` only if needed. Draft 3 candidates internally. Pick best.

Rules:

- format: `<type>(optional-scope): short description`
- default types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `perf`
- lowercase only
- max 72 chars
- no trailing period
- reflect staged intent, not low-level detail
- if mixed concerns, pick dominant one

Output:

- chosen message only, one line
- then exactly: `Type 'continue' to commit or anything else to cancel.`

Apply:

- commit only if next user reply is exactly `continue`
- then run `git commit -m "<message>"`
- never use `--no-verify`
- otherwise exit silently
