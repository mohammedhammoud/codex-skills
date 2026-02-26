---
name: refactor
description: Propose minimal, safe code improvements without changing behavior
---

Use this skill to improve structure, readability, and maintainability without changing behavior.

USAGE (required)

- `$refactor staged`
- `$refactor changes`
- `$refactor <file-path>`

If argument is missing, print ONLY:
`Usage: $refactor staged | $refactor changes | $refactor <file-path>`
and exit.

MODE

- `staged`: run `git diff --cached --stat` and `git diff --cached`
- `changes`: run `git diff --stat` and `git diff`
- `<file-path>`: verify file exists, read only that file, refactor only that file

RULES

- Preserve behavior exactly.
- Preserve external contracts (public API, file/module names, exported symbols, schemas, interfaces, signatures) unless explicitly requested.
- No new features, no bug-fix scope creep, no architectural rewrites.
- Keep diffs small and local.
- Improve only:
  - duplication (DRY)
  - naming clarity
  - readability
  - dead code removal (only if provably unused in scope)
  - replacing repeated literals with well-named constants (avoid magic numbers/strings)
  - consistency and non-breaking safety checks
- Do NOT weaken correctness guarantees for convenience (e.g. broader/looser typing, unsafe casts, catch-all fallbacks, removed validations).
- Do NOT bypass static checks with shortcuts (language-agnostic): disabling type/lint rules, broad suppressions, blanket ignores, or “trust me” casts/assertions.
- Keep error handling semantics and null/empty/default behavior equivalent.
- If safety cannot be guaranteed from available context, print:
  `Refactor canceled: cannot guarantee behavior safety within scope.`
  and stop.

SELF-ITERATION (required)

Before proposing the patch:
1. Produce a first draft.
2. Critique it for avoidable churn, behavior drift risk, and safety-check bypasses.
3. Refine once more before presenting.
Do this internally; do not ask the user during this loop.

DO NOT

- Modify unrelated files.
- Run tests.
- Create commits.
- Open pull requests.
- Trigger CI.
- Invoke other skills.

OUTPUT FORMAT

1. Summary
2. Refactor Plan
3. Proposed Patch
4. Risk Level: low | medium | high

Then print exactly:
Type "continue" to apply this refactor.
Anything else cancels.

APPLY PHASE

Only if next user message is exactly `continue`:

- Apply only the described refactor.
- Modify only in-scope files for selected mode.
- Stop immediately after applying.

Then print:

- `git status --short`
- `git diff --stat`
