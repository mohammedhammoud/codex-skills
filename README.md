# ai-cli-skills

My personal Codex and GitHub Copilot skills and workflows.

I am sharing this repository publicly as a reference for how I work with AI-assisted development. These skills are optimized for my own setup and preferences, but parts of them may still be useful or adaptable for others.

If you want more context on the thinking behind this setup, I wrote about it here:

- <https://mohammedhammoud.com/blog/how-i-turned-codex-cli-into-a-structured-engineering-assistant/>

## 1. Structure

Follow the official skill guidance for the CLIs this repo targets:

- <https://platform.openai.com/docs/guides/skills>
- <https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills>

This repository uses the following layout:

- `<skill-name>/SKILL.md`
- `<skill-name>/scripts/...` (optional)
- `link.sh` (symlinks skills into supported local skill directories)

## 2. Install / Sync

Prerequisites:

- `git`
- Codex and/or GitHub Copilot CLI with local skills support
- `gh` CLI for workflows that create or update pull requests
- GitHub authentication configured for `gh` when using PR automation

```bash
git clone <your-fork-or-repo-url> ~/code/ai-cli-skills
cd ~/code/ai-cli-skills
./link.sh
```

The clone path above is only an example. Any local checkout path works.

What `./link.sh` does:

- If `~/.codex` exists, symlinks each skill directory from this repo into `~/.codex/skills`
- If `~/.copilot` exists, symlinks each skill directory from this repo into `~/.copilot/skills`
- Skips any CLI home directory that is not present

## 3. Typical Workflow

1. For bug investigations, invoke the `debug` skill first for strict, step-by-step root-cause analysis.
2. Make changes, or invoke the `refactor` skill for behavior-preserving structural cleanup.
3. Invoke the `review` skill.
4. Fix the changes if needed.
5. Invoke the `commit` skill.
6. Accept the suggested commit message.
7. Invoke the `create-pull-request` skill.
8. Continue if everything looks good.

For a mostly hands-off flow, I use the `lazy` skill to create a branch, implement the change, review it, commit it, push it, and open or update a draft PR.

## 4. Repo Notes

- Re-run `./link.sh` after adding a new skill folder.
- Some skills assume a GitHub-hosted repository and detect the relevant remote at runtime.
- This repository keeps skills global and symlinked; it does not sync `AGENTS.md` or other instruction files into CLI home directories.

## 5. Skills

- `commit`: Generate and optionally apply a Conventional Commit from staged changes (`commit/SKILL.md`)
- `create-pull-request`: Create or update a draft PR from git diff (title + body) (`create-pull-request/SKILL.md`)
- `debug`: Strict debugging that starts from a user-specified file, requires a clear problem statement, and follows execution flow layer by layer until root cause is proven or missing evidence is explicitly identified (`debug/SKILL.md`)
- `lazy`: Run the end-to-end delivery flow from a fresh branch through validation, commit, push, and draft PR (`lazy/SKILL.md`)
- `refactor`: Propose minimal, safe code improvements without changing behavior (`refactor/SKILL.md`)
- `review`: Review staged or unstaged changes for bugs, risks, and minimal risk-reducing fixes (`review/SKILL.md`)
