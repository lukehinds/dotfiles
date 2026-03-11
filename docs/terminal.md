# Terminal Stack

This repo manages a terminal-first workflow built around Ghostty, tmux, zsh, and a small set of supporting tools.

## Core pieces

- Ghostty is the terminal emulator and starts in a shared `tmux` session.
- tmux is the persistent workspace layer.
- zsh is the interactive shell.
- Powerlevel10k provides prompt rendering.

## Workflow tools

- `atuin` replaces plain shell history with searchable history and optional sync.
- `zoxide` replaces `z` while keeping the same `z` muscle memory.
- `direnv` loads project-local environment variables from `.envrc`.
- `fd` is the preferred file finder.
- `eza` provides richer directory listings.
- `delta` improves `git diff`, `git show`, and interactive staging views.
- `wt` shell integration is enabled automatically if the binary exists.

## Managed config

- Ghostty: `ghostty/.config/ghostty/config`
- tmux: `tmux/.config/tmux/tmux.conf`
- zsh: `zsh/.zshrc`
- Atuin: `atuin/.config/atuin/config.toml`
- Git: `git/.gitconfig`

## Notes

- `atuin` is initialized with `--disable-up-arrow`, so shell history on the up arrow keeps its usual behavior and `Ctrl-R` becomes the primary search entry point.
- `zoxide` is loaded if installed; otherwise the old `z` plugin path remains as a fallback.
- `direnv` is loaded at the end of `zshrc`, per its recommended setup.
- Ghostty is configured to launch tmux directly from its managed config.
