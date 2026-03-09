---
name: refactor
description: Propose minimal, safe code improvements without changing behavior
---

Use this skill to improve structure, readability, and maintainability without changing behavior.

Repository policy:

- Before applying this skill, read `AGENTS.md` (or equivalent repo-local instructions) if present.
- Repository-specific rules for validation, file scope, architecture, and output override this skill's generic defaults.
- If repository policy conflicts with the generic rules below, prefer repository policy and state the conflict briefly if needed.

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
- In the selected scope, batch clearly safe, behavior-preserving refactors into one coherent proposal rather than many tiny proposals.
- Split into multiple rounds only if combining them would materially increase behavior-drift risk or make review less safe.
- Before finishing, check whether any additional low-risk refactors remain in the same scope. If yes, include them in the same proposal.
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
1. Produce a first draft containing all safe refactors in scope.
2. Critique it for avoidable churn, behavior drift risk, over-batching, and safety-check bypasses.
3. Remove anything non-essential or risky.
4. Refine once more into one coherent batched proposal when safe.
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
- Include all worthwhile low-risk, behavior-preserving refactors in scope; do not artificially split independent safe cleanups into separate proposals.
4. Risk Level: low | medium | high

Then print exactly:
Type "continue" to apply this refactor.
Anything else cancels.

APPLY PHASE

Only if next user message is exactly `continue`:

- Apply the full proposed refactor set.
- Modify only in-scope files for selected mode.
- Stop immediately after applying.

Then print:

- `git status --short`
- `git diff --stat`
