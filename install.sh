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
            echo "Unknown Linux distro — skipping package install. Install zsh, git, curl, fzf manually."
            ;;
    esac
}

# -----------------------------
# Packages
# -----------------------------
install_packages

# -----------------------------
# Oh My Zsh
# -----------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# -----------------------------
# Powerlevel10k + plugins
# -----------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]]; then
    echo "Installing fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
fi

# -----------------------------
# Symlinks (after OMZ so our .zshrc wins)
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
