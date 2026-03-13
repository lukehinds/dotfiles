# Bootstrap

This page describes how to get a new machine onto the managed dotfiles setup and what the bootstrap script is expected to do.

## Standard flow

```bash
git clone https://github.com/lukehinds/dotfiles ~/dev/dotfiles
cd ~/dev/dotfiles
bash install.sh
```

## What `install.sh` does

The bootstrap process in [`install.sh`](/Users/lukehinds/dev/dotfiles/install.sh) is opinionated but intentionally small:

1. Detect the operating system.
2. Install core packages.
3. Install Starship prompt if missing.
4. Clone zsh plugins into `~/.zsh/plugins` if missing.
5. Run [`sync.sh`](/Users/lukehinds/dev/dotfiles/sync.sh) to place symlinks in `$HOME`.
6. Set `zsh` as the default shell if needed.

## Platform behavior

### macOS

- Installs Homebrew if it is missing.
- Runs `brew bundle --file=homebrew/Brewfile`.
- Installs WezTerm and the rest of the terminal stack from the Brewfile.

### Debian / Ubuntu

- Runs `apt-get update`.
- Installs the current package set directly in [`install.sh`](/Users/lukehinds/dev/dotfiles/install.sh).

### RHEL / Fedora / Amazon Linux

- Uses `dnf` if present, otherwise `yum`.
- Installs the current package set directly in [`install.sh`](/Users/lukehinds/dev/dotfiles/install.sh).

### Arch / Manjaro

- Uses `pacman`.
- Installs the current package set directly in [`install.sh`](/Users/lukehinds/dev/dotfiles/install.sh).

## Symlinked files

The repo uses symlinks rather than copying config into place. Editing live files in `$HOME` edits the repo-managed sources directly.

Current managed targets include:

- `~/.zshrc`
- `~/.gitconfig`
- `~/.config/atuin/config.toml`
- `~/.config/starship.toml`
- `~/.config/wezterm/wezterm.lua`
- `~/.config/wezterm/config.lua`
- `~/.config/wezterm/events.lua`

## Local-only state

Some configuration should stay outside the repo:

- `~/.zsh_local` for secrets, work tokens, local PATH tweaks, and machine-specific shell settings
- `~/.gitconfig.local` for Git settings that should not be committed

## Maintenance notes

- On macOS, prefer updating [`homebrew/Brewfile`](/Users/lukehinds/dev/dotfiles/homebrew/Brewfile) after package changes.
- On Linux, package changes currently require editing [`install.sh`](/Users/lukehinds/dev/dotfiles/install.sh) directly.
- If a tool is optional, guard it in [`zsh/.zshrc`](/Users/lukehinds/dev/dotfiles/zsh/.zshrc) with `command -v` or file checks.
