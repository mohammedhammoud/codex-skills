# codex-skills

My personal Codex skills and workflows, versioned in Git.

I am sharing this repository publicly as a reference for how I work with AI-assisted development. These skills are optimized for my own setup and preferences, but parts of them may still be useful or adaptable for others.

If you want more context on the thinking behind this setup, I wrote about it here:

- <https://mohammedhammoud.com/blog/how-i-turned-codex-cli-into-a-structured-engineering-assistant/>

## 1. Structure

Follow OpenAI's official guidance for skill structure and conventions:

- <https://platform.openai.com/docs/guides/skills>

Repository layout used here:

- `<skill-name>/SKILL.md`
- `<skill-name>/scripts/...` (optional)
- `link.sh` (symlinks skills into `~/.codex/skills`)

## 2. Install / Sync

Prerequisites:

- `git`
- Codex with local skills support
- `gh` CLI for workflows that create or update pull requests
- GitHub authentication configured for `gh` when using PR automation

```bash
git clone <your-fork-or-repo-url> ~/code/codex-skills
cd ~/code/codex-skills
./link.sh
```

The clone path above is only an example. Any local checkout path works.

What this does:

- Creates `~/.codex/skills` if needed
- Symlinks each skill directory from this repo into `~/.codex/skills`
- Keeps `~/.codex/skills/.system` untouched

## 3. How We Work

Standard flow:

1. For bug investigations, run `$debug` first to perform strict, step-by-step root-cause analysis.
2. Make changes (or run `$refactor` for behavior-preserving structural cleanup)
3. Run `$review`
4. Fix changes if needed
5. Run `$commit`
6. Accept commit message
7. Run `$create-pull-request`
8. Continue if everything looks good

If you want a mostly hands-off flow, run `$lazy` to create a branch, implement the change, review it, commit it, push it, and open or update a draft PR.

## 4. Notes

- This repo should only contain user-defined skills.
- Do not modify `~/.codex/skills/.system` manually.
- Prefer small, focused commits.
- Re-run `./link.sh` after adding a new skill folder.
- Some skills assume a GitHub-hosted repository and detect the relevant remote at runtime.

## 5. Skills

- `commit`: Generate and optionally apply a Conventional Commit from staged changes (`commit/SKILL.md`)
- `create-pull-request`: Create or update a draft PR from git diff (title + body) (`create-pull-request/SKILL.md`)
- `debug`: Strict debugging that starts from a user-specified file, requires a clear problem statement, and follows execution flow layer by layer until root cause is proven or missing evidence is explicitly identified (`debug/SKILL.md`)
- `lazy`: Run the end-to-end delivery flow from a fresh branch through validation, commit, push, and draft PR (`lazy/SKILL.md`)
- `refactor`: Propose minimal, safe code improvements without changing behavior (`refactor/SKILL.md`)
- `review`: Review staged or unstaged changes for bugs, risks, and minimal risk-reducing fixes (`review/SKILL.md`)
