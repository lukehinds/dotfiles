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

ensure_tmux_plugins() {
    if ! command -v tmux &>/dev/null; then
        return
    fi

    local tpm_path="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

    if [[ ! -d "$tpm_path" ]]; then
        if command -v git &>/dev/null; then
            echo "Installing tmux plugin manager..."
            mkdir -p "$(dirname "$tpm_path")"
            git clone https://github.com/tmux-plugins/tpm "$tpm_path"
        else
            echo "Skipping tmux plugin manager install: git not found"
            return
        fi
    fi

    if [[ -x "$tpm_path/bin/install_plugins" ]]; then
        echo "Installing tmux plugins..."
        "$tpm_path/bin/install_plugins" >/dev/null 2>&1 || true
    fi
}

# -----------------------------
# Symlinks
# -----------------------------
link zsh/.zshrc .zshrc
link zsh/.p10k.zsh .p10k.zsh
link atuin/.config/atuin/config.toml .config/atuin/config.toml
link git/.gitconfig .gitconfig
link ghostty/.config/ghostty/config .config/ghostty/config
link tmux/.config/tmux/tmux.conf .config/tmux/tmux.conf
link tmux/.config/tmux/tmux.reset.conf .config/tmux/tmux.reset.conf
link tmux/.config/tmux/scripts/status-context.sh .config/tmux/scripts/status-context.sh
link tmux/.config/tmux/scripts/window-name.sh .config/tmux/scripts/window-name.sh
link tmux/.config/tmux/scripts/worktree-name.sh .config/tmux/scripts/worktree-name.sh
link tmux/.config/tmux/worktree-status.conf .config/tmux/worktree-status.conf

# Create .zsh_local from template if it doesn't exist
if [[ ! -f "$HOME/.zsh_local" ]]; then
    cp "$DOTFILES/zsh/.zsh_local.template" "$HOME/.zsh_local"
    echo "Created ~/.zsh_local from template — add your secrets and machine-specific config there"
fi

ensure_tmux_plugins

echo "Dotfiles synced."
