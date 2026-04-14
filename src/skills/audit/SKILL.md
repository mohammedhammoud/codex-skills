---
name: audit
description: Audit staged, unstaged, or file-scoped changes for bugs, risks, and minimal risk-reducing fixes
argument-hint: "staged | changes | <file-path>"
---

Arg: `staged` | `changes` | `<file-path>`.
If missing: print only `Usage: audit staged | audit changes | audit <file-path>`; exit.
Read `AGENTS.md` first. Repo rules win.

Scope:

- `staged`: run `git diff --cached --stat`, then `git diff --cached`
- `changes`: run `git diff --stat`, then `git diff`
- `<file-path>`:
  - run `git diff --cached --stat -- <file-path>`
  - run `git diff --cached -- <file-path>`
  - run `git diff --stat -- <file-path>`
  - run `git diff -- <file-path>`
  - path may be deleted or renamed
  - if both diffs empty, print only `No changes found for <file-path>.` and exit

Rules:

- Inspect diff only.
- No full-repo scan.
- Do not test, modify files, or commit.
- If diff is not enough to prove a claim, say so.
- functional bugs
- regressions
- edge-case risk
- i18n violations
- TypeScript looseness: `any`, unsafe casts
- missing tests
- accessibility issues
- architectural drift visible in diff

Only report missing tests when changed behavior clearly needs coverage.
Only suggest minimal behavior-preserving fixes.
No architectural refactors.
`None` is valid.

Output:

- Caveman style. Fragments.
- `Blocking: ...`
- `Bugs: ...`
- `Risky patterns: ...`
- `Missing tests: ...`
- `Risk: low | medium | high`
If risk != low: propose minimal fix, list files, say why, then print `Type 'continue' to apply the fix or anything else to cancel.`
If risk = low: print `No changes required.` No refactors. No continue text.
