#!/usr/bin/env bash
path="${1:-.}"
toplevel="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)" && {
    repo="$(basename "$toplevel")"
    # Check if we're in a worktree (not the main repo)
    commondir="$(git -C "$path" rev-parse --git-common-dir 2>/dev/null)"
    gitdir="$(git -C "$path" rev-parse --git-dir 2>/dev/null)"
    if [[ "$commondir" != "$gitdir" ]]; then
        branch="$(git -C "$path" branch --show-current 2>/dev/null)"
        printf '%s/%s' "$repo" "${branch:-wt}"
    else
        printf '%s' "$repo"
    fi
    exit 0
}
basename "$path"
