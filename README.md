# dotfiles

Personal dotfiles for my zsh and dev environment setup. Uses symlinks so edits to live config are reflected directly in the repo.

## Bootstrap a new machine

```bash
git clone https://github.com/lukehinds/dotfiles ~/dev/dotfiles
cd ~/dev/dotfiles
bash install.sh
```

`install.sh` detects the OS and:
- Symlinks `~/.zshrc` to `zsh/.zshrc`
- Symlinks `~/.gitconfig`
- Symlinks `~/.config/atuin/config.toml`
- Symlinks `~/.config/ghostty/config`
- Symlinks `~/.config/tmux/tmux.conf` and `tmux.reset.conf`
- Creates `~/.zsh_local` from the template if it doesn't exist
- Installs Oh My Zsh, Powerlevel10k, zsh plugins, and tmux TPM/plugins
- Sets zsh as the default shell if it isn't already
- **macOS**: installs Homebrew if missing, then runs `brew bundle`
- **Debian/Ubuntu**: runs `apt-get install` for core packages, including `tmux`
- **RHEL/Fedora/Amazon Linux**: runs `dnf` or `yum`, including `tmux`
- **Arch**: runs `pacman`, including `tmux`

## Secrets and machine-specific config

`~/.zsh_local` is sourced at the end of `.zshrc` and is never committed. Add API keys, work-specific env vars, and machine-specific PATH entries there.

A template is provided at `zsh/.zsh_local.template`.

## Structure

```
dotfiles/
├── install.sh
├── homebrew/
│   └── Brewfile
├── atuin/
│   └── .config/
│       └── atuin/
│           └── config.toml
├── docs/
│   ├── index.md
│   └── terminal.md
├── git/
│   └── .gitconfig
├── ghostty/
│   └── .config/
│       └── ghostty/
│           └── config
├── tmux/
│   └── .config/
│       └── tmux/
│           ├── tmux.conf
│           └── tmux.reset.conf
└── zsh/
    ├── .zshrc
    └── .zsh_local.template
```

## Tmux

The tmux module is adapted from [omerxx/dotfiles](https://github.com/omerxx/dotfiles), with the path-specific parts removed so it works in this repo:

- Uses `~/.config/tmux` instead of a hard-coded dotfiles path
- Uses the official `catppuccin/tmux` plugin instead of the upstream personal fork
- Leaves session-specific overrides to an optional `~/.config/tmux/local.conf`

If you want to add machine-specific session paths or plugin overrides, create `~/.config/tmux/local.conf` and set them there.

`sync.sh` now also ensures TPM is present and runs plugin installation when `tmux` is available, so tmux theme/plugin changes are applied as part of sync rather than requiring a separate manual step.

## Ghostty

Ghostty is configured via `~/.config/ghostty/config` and is symlinked from this repo. The default config starts or attaches to the `main` tmux session on launch:

```conf
command = direct:/opt/homebrew/bin/tmux new-session -A -s main
```

## Shell Workflow

The shell setup now assumes a small set of terminal quality-of-life tools when available:

- `atuin` for searchable shell history
- `zoxide` for smarter directory jumping via `z` and `zi`
- `direnv` for project-local environment loading
- `eza` and `fd` for faster file navigation
- `delta` for improved Git diffs
- optional `wt` shell integration when the Worktree helper is installed

All of these are guarded in `zsh/.zshrc`, so machines missing a tool will still start cleanly.

## Recommended Workflow

The intended workflow is:

1. Open Ghostty.
2. Attach to the persistent tmux session.
3. Use `zoxide` and `git worktree` to move into a task-specific checkout.
4. Use `direnv` for project-local env, `atuin` for history, and `delta` for review.

This setup is designed to work well with plain `git worktree` and also with optional Worktree helpers that provide a `wt` CLI.

## Local Git config

Git is now managed via `~/.gitconfig`, with existing user identity settings preserved and `delta` enabled as the pager. If you want to keep machine-specific or uncommitted Git preferences out of the repo, add them to `~/.gitconfig.local`; the managed config will include it automatically if present.

## Docs

There is now a local `docs/` tree and `mkdocs.yml` so repo documentation can grow alongside the config. Current docs cover bootstrap, shell tooling, Git defaults, and the intended daily worktree-based workflow.

## Adding new machines / apps

Apps that may not be installed on every machine are guarded in `.zshrc` with `command -v` or file existence checks, so missing tools are silently skipped rather than causing errors.

To add a new tool:

```zsh
# binary guard
command -v mytool &>/dev/null && eval "$(mytool init -)"

# file guard
[[ -f "$HOME/.mytool/init.zsh" ]] && source "$HOME/.mytool/init.zsh"
```

## Keeping Brewfile up to date

After installing new packages on any machine:

```bash
brew bundle dump --file=~/dev/dotfiles/homebrew/Brewfile --force
```

## Forking for your own use

1. Fork this repo on GitHub, then clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles ~/dev/dotfiles
   cd ~/dev/dotfiles
   ```

2. Review `zsh/.zshrc` and remove or replace anything specific to this setup —
   look for tool references you don't use (pyenv, fnm, gvm, openclaw, etc.) and
   any macOS-specific paths you don't need.

3. Replace `zsh/.p10k.zsh` with your own, or delete it and run `p10k configure`
   after bootstrapping to generate a fresh one.

4. On macOS, generate a `Brewfile` from your currently installed packages:

   ```bash
   mkdir -p homebrew
   brew bundle dump --file=homebrew/Brewfile
   ```

   On Linux, edit the package lists in `install.sh` under each distro's section
   to match the tools you want installed.

5. Copy `zsh/.zsh_local.template` to `~/.zsh_local` and add your own secrets
   and machine-specific config. Never commit `~/.zsh_local`.

6. Run `bash install.sh` to apply everything.

7. Since the files are symlinked, any edits you make to your live config (e.g.
   `~/.zshrc`) are edits directly in the repo. Commit and push to keep your fork
   up to date:

   ```bash
   cd ~/dev/dotfiles
   git add -p
   git commit -m "your message"
   git push
   ```

   On a new machine, just clone and run `install.sh` — you'll be back to your
   exact setup immediately.
