# Shell Workflow

The shell layer is managed in [`zsh/.zshrc`](/Users/lukehinds/dev/dotfiles/zsh/.zshrc) and aims to keep startup predictable while allowing optional tools to appear automatically when installed.

## Prompt

- Oh My Zsh provides the framework layer.
- Powerlevel10k is the active theme.
- Instant prompt is enabled when the cache file exists.

## History

[`atuin/.config/atuin/config.toml`](/Users/lukehinds/dev/dotfiles/atuin/.config/atuin/config.toml) defines the current Atuin behavior.

Key choices:

- compact UI
- previews enabled
- workspace-aware history
- up-arrow behavior left alone

This keeps `Ctrl-R` as the main history search path while preserving conventional shell navigation.

Useful Atuin habits:

- `Ctrl-R` to search prior commands by fuzzy match
- prefer reusing real commands from history rather than rebuilding them from memory
- let workspace-aware history keep repo-local commands easier to find

## Directory jumping

`zoxide` is the preferred directory jumping tool and keeps the familiar `z` command. If `zoxide` is not installed, the old `z` plugin path is still loaded as a fallback.

Typical usage:

```bash
z dotfiles
zi
```

## Environment loading

`direnv` is loaded at the end of `.zshrc`, which is the safest place for it. Use `.envrc` for per-project environment variables rather than putting project-specific exports into global shell config.

Typical usage:

```bash
echo 'export FOO=bar' > .envrc
direnv allow
```

## File navigation

If available:

- `fd` is exposed with the `ff` alias for fast file lookup
- `eza` replaces the plain `ls` experience
- `bat` replaces `cat` for readable file output

These are all guarded, so the shell still works if a tool is missing on a given machine.

Useful commands:

```bash
ff tmux
ll
lt
cat README.md
```

## Optional Worktree helper

If a `wt` binary is installed, `.zshrc` initializes its shell integration automatically:

```zsh
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
```

This is optional. The baseline workflow still assumes standard `git worktree`.

## Local overrides

Use `~/.zsh_local` for:

- secrets
- work-only paths
- machine-specific aliases
- anything that should not be committed

That file is sourced near the end of `.zshrc`.
