#!/usr/bin/env bash
# Symlinks the economy-mode skill into the Claude Code skills directory.
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
source_dir="$repo_root/skills/economy-mode"
skills_dir="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
target="$skills_dir/economy-mode"

if [ ! -d "$source_dir" ]; then
    echo "error: skill directory not found: $source_dir" >&2
    exit 1
fi

mkdir -p "$skills_dir"

if [ -L "$target" ]; then
    current=$(readlink -f "$target")
    if [ "$current" = "$source_dir" ]; then
        echo "already installed: $target -> $source_dir"
        exit 0
    fi
    echo "error: $target is a symlink to a different location: $current" >&2
    echo "remove it yourself if you want to replace it" >&2
    exit 1
fi

if [ -e "$target" ]; then
    echo "error: $target already exists and is not a symlink" >&2
    echo "remove it yourself if you want to replace it" >&2
    exit 1
fi

ln -s "$source_dir" "$target"
echo "installed: $target -> $source_dir"
