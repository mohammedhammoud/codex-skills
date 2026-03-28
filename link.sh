#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(
  "codex:${HOME}/.codex"
  "copilot:${HOME}/.copilot"
)

cleanup_stale_links() {
  local dest="$1"
  local label="$2"
  local dest_name entry expected_target target

  mkdir -p "$dest"

  for entry in "$dest"/*; do
    [ -L "$entry" ] || continue
    dest_name="$(basename "$entry")"
    expected_target="$ROOT/$dest_name"
    target="$(readlink "$entry")" || continue

    [ "$target" = "$expected_target" ] || continue

    if [ ! -f "$expected_target/SKILL.md" ]; then
      rm -f "$entry"
      echo "$label: removed stale $dest_name"
    fi
  done
}

link_skills() {
  local dest="$1"
  local label="$2"
  local skill

  mkdir -p "$dest"

  for skill in "$ROOT"/*; do
    [ -f "$skill/SKILL.md" ] || continue
    ln -sfn "$skill" "$dest/$(basename "$skill")"
    echo "$label: linked $(basename "$skill")"
  done
}

for target in "${TARGETS[@]}"; do
  label="${target%%:*}"
  home="${target#*:}"
  dest="${home}/skills"

  if [ -d "$home" ]; then
    cleanup_stale_links "$dest" "$label"
    link_skills "$dest" "$label"
  else
    echo "$label: skipped, $home does not exist"
  fi
done
