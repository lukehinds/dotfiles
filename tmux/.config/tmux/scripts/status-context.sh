#!/usr/bin/env bash
set -euo pipefail

path="${1:-}"

if [[ -z "$path" ]]; then
    exit 0
fi

if ! repo_root="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)"; then
    exit 0
fi

branch=""
ahead=0
behind=0
staged=0
modified=0
untracked=0
stashed=0

while IFS= read -r line; do
    case "$line" in
        '# branch.head '*)
            branch="${line#\# branch.head }"
            ;;
        '# branch.ab '*)
            if [[ "$line" =~ \+([0-9]+) ]]; then
                ahead="${BASH_REMATCH[1]}"
            fi
            if [[ "$line" =~ -([0-9]+) ]]; then
                behind="${BASH_REMATCH[1]}"
            fi
            ;;
        '1 '*|'2 '*)
            x="${line:2:1}"
            y="${line:3:1}"
            [[ "$x" != "." ]] && ((staged+=1))
            [[ "$y" != "." ]] && ((modified+=1))
            ;;
        '? '*)
            ((untracked+=1))
            ;;
    esac
done < <(git -C "$path" status --porcelain=2 --branch 2>/dev/null)

if git -C "$path" rev-parse --verify refs/stash >/dev/null 2>&1; then
    stashed=1
fi

if [[ -z "$branch" || "$branch" == "(detached)" ]]; then
    branch="$(basename "$repo_root")"
fi

segment() {
    local bg="$1"
    local text="$2"
    printf '#[fg=%s,bg=default,nobold,nounderscore,noitalics]#[fg=black,bg=%s,nobold] %s #[fg=%s,bg=default,nobold,nounderscore,noitalics]' "$bg" "$bg" "$text" "$bg"
}

segment colour152 "$branch"
((ahead > 0)) && segment colour150 "~${ahead}"
((behind > 0)) && segment colour217 "-${behind}"
((staged > 0)) && segment colour114 "+${staged}"
((modified > 0)) && segment colour223 "!${modified}"
((untracked > 0)) && segment colour182 "?${untracked}"
((stashed > 0)) && segment colour110 "*"
