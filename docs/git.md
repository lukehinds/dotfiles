# Git Workflow

This repo now manages a baseline Git config in [`git/.gitconfig`](/Users/lukehinds/dev/dotfiles/git/.gitconfig).

## Managed defaults

The managed Git config currently sets:

- user name
- user email
- signing key
- commit signing on by default
- global excludes file
- `delta` as the pager
- `zdiff3` merge conflict style

It also includes `~/.gitconfig.local` automatically so machine-specific or temporary settings can live outside the repo.

## Worktree-first model

The preferred way to work in this setup is with `git worktree`, not repeated branch switching in a single checkout.

That means:

- keep the main checkout clean
- create one worktree per feature or fix
- use tmux windows and `zoxide` to move between active worktrees quickly

Example:

```bash
cd ~/dev/my-repo
git fetch origin
git worktree add ../my-repo-feature -b feature/my-change origin/main
cd ../my-repo-feature
```

List current worktrees:

```bash
git worktree list
```

Remove a finished worktree:

```bash
git worktree remove ../my-repo-feature
git worktree prune
```

## Delta

`delta` is enabled as the default pager for Git output. This improves:

- `git diff`
- `git show`
- interactive staging output

Current defaults:

- side-by-side diff view
- line numbers
- keyboard navigation

If those defaults become too wide for a laptop display, adjust [`git/.gitconfig`](/Users/lukehinds/dev/dotfiles/git/.gitconfig) rather than overriding ad hoc.

## Suggested local additions

The repo intentionally avoids managing credentials or host-specific Git transport details. Good candidates for `~/.gitconfig.local` include:

- credential helpers
- per-work identity overrides
- URL rewrites
- editor preferences
- GPG or SSH agent tweaks that are not portable

## Review habits

For this setup, the most useful commands remain:

```bash
git status
git diff
git add -p
git show
```

The repo is designed around reviewing actual config changes rather than regenerating large machine-local artifacts.
