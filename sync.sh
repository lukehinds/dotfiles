#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dest="$HOME/$2"
    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "Backing up existing $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi
    ln -sf "$src" "$dest"
    echo "Linked $dest -> $src"
}

# -----------------------------
# Symlinks
# -----------------------------
link zsh/.zshrc .zshrc
link zsh/.p10k.zsh .p10k.zsh
link ghostty/.config/ghostty/config .config/ghostty/config
link tmux/.config/tmux/tmux.conf .config/tmux/tmux.conf
link tmux/.config/tmux/tmux.reset.conf .config/tmux/tmux.reset.conf
link tmux/.config/tmux/scripts/status-context.sh .config/tmux/scripts/status-context.sh

# Create .zsh_local from template if it doesn't exist
if [[ ! -f "$HOME/.zsh_local" ]]; then
    cp "$DOTFILES/zsh/.zsh_local.template" "$HOME/.zsh_local"
    echo "Created ~/.zsh_local from template — add your secrets and machine-specific config there"
fi

echo "Dotfiles synced."
