---
name: split-commits
description: Group current changes into multiple commitlint-compliant commits and apply on confirmation
argument-hint: "Optional: focus area or grouping preference"
---

Analyze current changes. Split into coherent commits.
Read `AGENTS.md` first. Repo commit rules win.
If commitlint config exists, it is authoritative.

Workflow:
1. Inspect changes:
   - `git status --short`
   - `git diff --stat`
   - `git diff --cached --stat`
   - read full diffs only when summaries are not enough
2. Propose commit plan grouped by intent.
   - prefer file-boundary grouping for safe staging
   - avoid splitting one file across commits unless user asked
   - keep commit count minimal but meaningful
3. Generate one message per planned commit.
4. Validate messages against repo or commitlint rules.

Message Rules:
- format: `<type>(optional-scope): short description`
- types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `perf`
- lowercase only
- max 72 chars
- no trailing period
- describe outcome or intent, not low-level detail

Output:
- print full commit plan in order
- for each commit include:
  - commit number
  - commit message
  - short file list
- then print exactly:
  `Type 'continue' to create these commits or anything else to cancel.`

Apply:
- create commits only if next reply is exactly `continue`
- commit in proposed order
- stage only files or hunks that belong to each commit
- never use `--no-verify`
- if safe non-interactive staging is not possible, stop and report blocker
- otherwise exit silently on any other reply
- print created commit SHAs in order
