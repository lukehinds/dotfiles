#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        ubuntu|debian|pop) OS="debian" ;;
        fedora|rhel|centos|amzn) OS="rhel" ;;
        arch|manjaro) OS="arch" ;;
        *) OS="linux-unknown" ;;
    esac
fi

echo "Detected OS: $OS"

# -----------------------------
# Helpers
# -----------------------------

install_packages() {
    case "$OS" in
        macos)
            if ! command -v brew &>/dev/null; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            if [[ -f "$DOTFILES/homebrew/Brewfile" ]]; then
                echo "Installing packages from Brewfile..."
                brew bundle --file="$DOTFILES/homebrew/Brewfile"
            fi
            ;;
        debian)
            echo "Installing packages via apt..."
            sudo apt-get update -qq
            sudo apt-get install -y zsh git curl fzf ripgrep bat
            ;;
        rhel)
            echo "Installing packages via dnf/yum..."
            if command -v dnf &>/dev/null; then
                sudo dnf install -y zsh git curl fzf ripgrep
            else
                sudo yum install -y zsh git curl
            fi
            ;;
        arch)
            echo "Installing packages via pacman..."
            sudo pacman -Sy --noconfirm zsh git curl fzf ripgrep bat
            ;;
        *)
            echo "Unknown Linux distro -- skipping package install. Install zsh, git, curl, fzf manually."
            ;;
    esac
}

# -----------------------------
# Packages
# -----------------------------
install_packages

# -----------------------------
# Starship prompt
# -----------------------------
if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# -----------------------------
# Zsh plugins
# -----------------------------
ZSH_PLUGINS="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS"

if [[ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi

if [[ ! -d "$ZSH_PLUGINS/fast-syntax-highlighting" ]]; then
    echo "Installing fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_PLUGINS/fast-syntax-highlighting"
fi

# -----------------------------
# Symlinks
# -----------------------------
"$DOTFILES/sync.sh"

# -----------------------------
# Set zsh as default shell
# -----------------------------
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    echo "Setting zsh as default shell..."
    if [[ "$OS" == "macos" ]]; then
        chsh -s "$(command -v zsh)"
    else
        # On Linux, zsh may not be in /etc/shells yet
        ZSH_PATH="$(command -v zsh)"
        if ! grep -q "$ZSH_PATH" /etc/shells; then
            echo "$ZSH_PATH" | sudo tee -a /etc/shells
        fi
        chsh -s "$ZSH_PATH"
    fi
fi

echo "Done. Open a new shell or: exec zsh"
