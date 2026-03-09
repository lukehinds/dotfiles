# Dotfiles update checker
# Sourced by .zshrc -- checks for remote updates on a schedule.

_dotfiles_check_update() {
    local dotfiles_dir check_file last_check now interval
    # Resolve dotfiles dir from the .zshrc symlink target
    dotfiles_dir="$(dirname "$(dirname "$(readlink -f "${HOME}/.zshrc")")")"
    check_file="${HOME}/.dotfiles_last_check"
    interval=$((12 * 3600))  # 12 hours in seconds

    # Bail if dotfiles repo doesn't exist
    [[ -d "$dotfiles_dir/.git" ]] || return 0

    now=$(date +%s)

    # Read last check timestamp
    if [[ -f "$check_file" ]]; then
        last_check=$(<"$check_file")
    else
        last_check=0
    fi

    # Skip if checked recently
    (( now - last_check < interval )) && return 0

    # Record this check
    echo "$now" > "$check_file"

    # Fetch with a short timeout to avoid blocking on bad networks
    git -C "$dotfiles_dir" fetch --quiet 2>/dev/null &
    local fetch_pid=$!

    # Wait up to 5 seconds for fetch
    local waited=0
    while kill -0 "$fetch_pid" 2>/dev/null && (( waited < 5 )); do
        sleep 1
        (( waited++ ))
    done

    # If fetch is still running, kill it and bail
    if kill -0 "$fetch_pid" 2>/dev/null; then
        kill "$fetch_pid" 2>/dev/null
        wait "$fetch_pid" 2>/dev/null
        return 0
    fi
    wait "$fetch_pid" 2>/dev/null || return 0

    # Compare local HEAD with remote
    local local_head remote_head
    local_head=$(git -C "$dotfiles_dir" rev-parse HEAD 2>/dev/null) || return 0
    remote_head=$(git -C "$dotfiles_dir" rev-parse @{u} 2>/dev/null) || return 0

    if [[ "$local_head" != "$remote_head" ]]; then
        echo "[dotfiles] Updates available. Run: cd $dotfiles_dir && git pull && ./sync.sh"
        read -r "reply?[dotfiles] Sync now? [y/N] "
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            git -C "$dotfiles_dir" pull --ff-only && "$dotfiles_dir/sync.sh"
            echo "[dotfiles] Synced. Reloading shell..."
            exec zsh
        fi
    fi
}

_dotfiles_check_update
unfunction _dotfiles_check_update 2>/dev/null
