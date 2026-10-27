#!/usr/bin/env bash
# Installs the video-shotcraft Claude Code skill (https://github.com/Vincentwei1021/video-shotcraft)
# into ~/.claude/skills at a pinned commit. Cloud containers are ephemeral, so this runs on each session start.
set -euo pipefail

REPO_URL="https://github.com/Vincentwei1021/video-shotcraft.git"
PINNED_SHA="43bd349a136651865ecfa6ea1cf012f6e957d304"
TARGET="${HOME}/.claude/skills/video-shotcraft"

if [ -f "${TARGET}/SKILL.md" ] && [ "$(git -C "${TARGET}" rev-parse HEAD 2>/dev/null)" = "${PINNED_SHA}" ]; then
  exit 0
fi

rm -rf "${TARGET}"
mkdir -p "${TARGET}"
git -C "${TARGET}" init -q
git -C "${TARGET}" remote add origin "${REPO_URL}"
if ! git -C "${TARGET}" fetch -q --depth 1 origin "${PINNED_SHA}"; then
  echo "video-shotcraft: fetch failed; skill not installed" >&2
  rm -rf "${TARGET}"
  exit 0
fi
git -C "${TARGET}" checkout -q FETCH_HEAD
