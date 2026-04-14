# ai-cli-skills

Personal Codex and GitHub Copilot skills and workflows.

This repository is public as a reference for how I work with AI-assisted development. It is optimized for my own setup and preferences, but parts may still be useful for others.

If you want more background on the setup, I wrote about it here:

- <https://mohammedhammoud.com/blog/how-i-turned-codex-cli-into-a-structured-engineering-assistant/>

## Structure

Follow the official skill guidance for the CLIs this repo targets:

- <https://platform.openai.com/docs/guides/skills>
- <https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills>

Repository layout:

- `src/skills/<skill-name>/SKILL.md`
- `src/skills/<skill-name>/scripts/...` (optional)
- `src/instructions.md`
- `install.sh`

## Install / Sync

Prerequisites:

- `git`
- Codex and/or GitHub Copilot CLI with local skills support
- `gh` CLI for workflows that create or update pull requests
- GitHub authentication configured for `gh` when using PR automation
- `rtk` recommended

```bash
git clone <your-fork-or-repo-url> ~/code/ai-cli-skills
cd ~/code/ai-cli-skills
./install.sh
```

The path above is only an example.

What `./install.sh` does:

- Offers to install `rtk` if it is missing
- If `rtk` exists, offers to run `rtk init` for detected tools
- If `~/.codex` exists, symlinks each skill directory from `src/skills/` into `~/.codex/skills` and symlinks `src/instructions.md` into `~/.codex/AGENTS.md`
- If `~/.copilot` exists, symlinks each skill directory from `src/skills/` into `~/.copilot/skills` and symlinks `src/instructions.md` into `~/.copilot/copilot-instructions.md`
- Removes stale symlinks when a skill from this repo is renamed or removed
- Skips any CLI home directory that does not exist

## Typical Workflow

1. Use `debug` for root-cause investigation.
2. Make the change, or use `refactor` for behavior-preserving cleanup.
3. Use `audit`.
4. Fix anything the audit finds.
5. Use `commit`.
6. Accept the suggested commit message.
7. Use `create-or-update-pr`.

For a mostly hands-off flow, use `lazy`.

## Repo Notes

- Re-run `./install.sh` after changing `src/skills/` or `src/instructions.md`.
- `rtk` is preferred when installed, but raw commands still work.
- Some skills assume a GitHub-hosted repository and detect remotes at runtime.
- Skills and shared instructions are intended to be globally symlinked into supported CLI home directories.

## Skills

- `audit`: Review staged, unstaged, or file-scoped changes for bugs and risk
- `commit`: Generate and optionally apply a Conventional Commit from staged changes
- `create-or-update-pr`: Update an existing PR for the current branch, or create a draft PR from the diff
- `debug`: Debug from an entrypoint or symptom, then propose a minimal patch
- `lazy`: Run the end-to-end flow from branch creation through validation, commit, push, and draft PR
- `rebase`: Rebase the current branch onto the default branch, resolving only safe issues
- `refactor`: Propose minimal, safe code improvements without changing behavior
- `split-commits`: Group current changes into multiple coherent commits and apply them on confirmation
