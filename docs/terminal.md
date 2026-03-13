# Terminal Stack

This repo manages a terminal-first workflow built around WezTerm, zsh, and a small set of supporting tools.

## Core pieces

- WezTerm is the terminal emulator.
- zsh is the interactive shell.
- Starship provides prompt rendering with a catppuccin mocha palette.

## Workflow tools

- `atuin` replaces plain shell history with searchable history and optional sync.
- `zoxide` replaces `z` while keeping the same `z` muscle memory.
- `direnv` loads project-local environment variables from `.envrc`.
- `fd` is the preferred file finder.
- `eza` provides richer directory listings.
- `delta` improves `git diff`, `git show`, and interactive staging views.
- `wt` shell integration is enabled automatically if the binary exists.

## Managed config

- WezTerm: `wezterm/.config/wezterm/`
- Starship: `starship/starship.toml`
- zsh: `zsh/.zshrc`
- Atuin: `atuin/.config/atuin/config.toml`
- Git: `git/.gitconfig`

## Notes

- `atuin` is initialized with `--disable-up-arrow`, so shell history on the up arrow keeps its usual behavior and `Ctrl-R` becomes the primary search entry point.
- `zoxide` is loaded if installed; otherwise the old `z` plugin path remains as a fallback.
- `direnv` is loaded at the end of `zshrc`, per its recommended setup.
