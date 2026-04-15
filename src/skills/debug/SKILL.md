---
name: debug
description: Debug a bug from an entrypoint or symptom, prove root cause, propose a minimal patch
argument-hint: "[entrypoint] [expected] [actual] [repro] [mode quick|strict]"
---

Use for root-cause debugging from file, symptom, or error.

Input:

- Preferred: entrypoint, expected, actual, repro, optional error/logs/stack.
- Minimum: entrypoint or one concrete symptom.
- If input is incomplete: start with what exists; list missing context; ask only for the highest-value next detail.
- Modes: `quick` default; `strict` proves end to end.

Rules:

- Assume bug exists.
- Every claim needs code evidence.
- No broad refactors. No unrelated cleanup.
- Do not test, commit, or open PRs.

Workflow:

1. Start from entrypoint or symptom source.
2. Trace execution path step by step.
3. If not found, follow call chain one layer at a time.
4. In `quick`, give best evidence-backed hypothesis plus next verification step when proof is incomplete.
5. In `strict`, continue until root cause is proven end to end.

Output:

1. Root cause or best current hypothesis: file + line + explanation
2. Proof status:
   - proven evidence, or
   - strongest evidence so far + next verification step
3. Minimal fix: exact patch or snippet, when justified
4. Risk: low | medium | high

- Then print exactly: `Type "continue" to apply this minimal patch. Anything else cancels.`

Apply:
Apply only if next reply is exactly `continue`:

- apply only described minimal fix
- modify only referenced files
- do not refactor, test, commit, open PR, trigger CI, or invoke other skills
- stop immediately after applying
- `git status --short`
- `git diff --stat`
