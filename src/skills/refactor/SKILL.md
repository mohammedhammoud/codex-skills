---
name: refactor
description: Propose minimal, safe code improvements without changing behavior
argument-hint: "staged | changes | <file-path>"
---

Use for behavior-preserving cleanup.
Read `AGENTS.md` first. Repo rules win.
Arg: `staged` | `changes` | `<file-path>`.
If missing: print only `Usage: refactor staged | refactor changes | refactor <file-path>`; exit.

Scope:

- `staged`: run `git diff --cached --stat`, then `git diff --cached`
- `changes`: run `git diff --stat`, then `git diff`
- `<file-path>`: verify file exists, read only that file, refactor only that file

Rules:

- preserve behavior exactly
- preserve external contracts: public API, file/module names, exports, schemas, interfaces, signatures
- no new features, bug-fix creep, or architectural rewrites
- keep diff small and local
- batch clearly safe refactors in scope into one coherent proposal
- split only if batching raises behavior risk or review risk
- before finishing, check for any other low-risk refactors in same scope and include them
- improve only:
  - duplication
  - naming clarity
  - readability
  - dead code removal when provably unused in scope
  - repeated literals turned into well-named constants
  - consistency and non-breaking safety checks
- do not weaken correctness with loose typing, unsafe casts, broad fallbacks, removed validation, or static-check bypasses
- keep error handling and null/empty/default behavior equivalent
- if safety cannot be guaranteed, print `Refactor canceled: cannot guarantee behavior safety within scope.` and stop

Self-Check:

1. draft all safe refactors in scope
2. critique for churn, drift risk, over-batching, or safety bypasses
3. cut non-essential or risky parts
4. refine once into one coherent proposal

Do Not:

- modify unrelated files
- run tests
- create commits
- open PRs
- trigger CI
- invoke other skills

Output:

1. Summary
2. Refactor Plan
3. Proposed Patch
4. Risk Level: low | medium | high

Then print exactly:
`Type "continue" to apply this refactor.`
`Anything else cancels.`

Apply:

Apply only if next reply is exactly `continue`:

- apply full proposed refactor set
- modify only in-scope files
- stop immediately after applying
- `git status --short`
- `git diff --stat`
