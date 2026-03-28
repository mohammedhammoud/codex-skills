---
name: audit
description: Audit staged, unstaged, or file-scoped changes for bugs, risks, and minimal risk-reducing fixes
argument-hint: "staged | changes | <file-path>"
---

Expected input (required):

- `staged`
- `changes`
- `<file-path>`

Argument must be exactly one of:
- staged
- changes
- a file path or diff target path

If argument is missing:
Print ONLY:
Usage: audit staged | audit changes | audit <file-path>
Exit.

---

Repository policy:

- Before applying this skill, read `AGENTS.md` (or equivalent repo-local instructions) if present.
- Repository-specific rules for testing, risk tolerance, output shape, or review priorities override this skill's generic defaults.
- If repository policy conflicts with the generic rules below, prefer repository policy and state the conflict briefly if needed.

---

Behavior:

If argument is `staged`:
- Run: `git diff --cached --stat`
- Run: `git diff --cached`

If argument is `changes`:
- Run: `git diff --stat`
- Run: `git diff`

If argument is `<file-path>`:
- Run: `git diff --cached --stat -- <file-path>`
- Run: `git diff --cached -- <file-path>`
- Run: `git diff --stat -- <file-path>`
- Run: `git diff -- <file-path>`
- The path may refer to a deleted or renamed diff target and does not need to exist in the working tree.
- If both staged and unstaged diffs are empty for that path, print ONLY:
  `No changes found for <file-path>.`
  and exit.

Only inspect the diff output.
Do NOT scan the entire repository.
Do NOT run tests.
Do NOT modify files.
Do NOT commit.
If the diff alone is not enough to prove a claim, say so explicitly and lower confidence instead of guessing.

---

Audit goals:

Detect:

- Functional bugs
- Regressions
- Edge-case risks
- i18n violations (hardcoded UI strings)
- TypeScript looseness (`any`, unsafe casts)
- Missing tests
- Accessibility issues
- Architectural drift

Only report missing tests when the diff clearly adds or changes behavior that should be covered.
Only report architectural drift when it is directly visible in the diff.

Do NOT invent issues just to suggest changes.
It is valid to conclude that everything looks correct.

Only suggest changes if they:

- Reduce real risk
- Preserve behavior
- Are minimal and scoped

Do NOT propose architectural refactors.

---

Output format:

1. Blocking issues
2. Functional bugs
3. Risky patterns
4. Missing tests
5. Overall risk level: low | medium | high

If overall risk level is NOT low:

- Propose a minimal, behavior-preserving fix
- Clearly list affected files
- Explain why it reduces risk
- Then print:

Type 'continue' to apply the fix or anything else to cancel.

If overall risk level is low:

- Print: "No changes required."
- Do NOT propose refactors.
- Do NOT print the continue instruction.
