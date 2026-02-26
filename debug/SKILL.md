---
name: debug
description: Strict, evidence-driven root-cause debugging from a user-specified entrypoint file
---

Use this skill when the user wants to debug a specific issue starting from a known file.

REQUIRED INPUT

The user must provide:

1. Entrypoint file path
2. Expected behavior
3. Actual behavior
4. Exact error message (if any)
5. Steps to reproduce

If any of the above is missing:

- Do NOT start debugging.
- Print exactly which item is missing.
- Exit.

DEBUGGING PRINCIPLES

- Never guess.
- Never refactor broadly.
- Assume the bug exists.
- Prove each step before moving forward.
- Stay behavior-focused, not style-focused.

WORKFLOW

1. Inspect the provided entrypoint file.
2. Identify execution flow from that file.
3. Follow the runtime path step-by-step.
4. At each step:
   - State assumption
   - Validate against code
   - Confirm or eliminate
5. If no issue is found in the entrypoint:
   - Move one layer deeper in the call chain.
6. Continue until:
   - Root cause is proven
     OR
   - A clearly bounded hypothesis is formed.

DO NOT:

- Rewrite architecture
- Introduce new abstractions
- Suggest unrelated improvements
- Modify files automatically
- Run tests automatically

OUTPUT FORMAT

1. Root Cause
   - Exact file + line reference
   - Clear explanation

2. Proof
   - Why this causes the observed behavior

3. Minimal Fix
   - Smallest possible change

4. Risk Level
   - low | medium | high

If root cause cannot be fully proven:

- Clearly state strongest hypothesis
- Explain what evidence is missing
- Ask for the minimal additional data needed

Be precise.
Be concise.
No fluff.
No generic advice.
