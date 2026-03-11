#!/usr/bin/env bash
path="${1:-.}"
git -C "$path" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

commondir="$(git -C "$path" rev-parse --git-common-dir 2>/dev/null)"
gitdir="$(git -C "$path" rev-parse --git-dir 2>/dev/null)"

if [[ "$commondir" != "$gitdir" ]]; then
    branch="$(git -C "$path" branch --show-current 2>/dev/null)"
    printf '%s' "${branch:-worktree}"
fi
