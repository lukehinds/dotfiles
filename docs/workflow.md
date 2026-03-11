# Daily Workflow

This repo is set up for a terminal-first workflow built around Ghostty, tmux, zsh, and Git worktrees.

## Default shape

The intended flow is:

1. Open Ghostty.
2. Ghostty starts or attaches to the `main` tmux session.
3. tmux starts a login `zsh`.
4. `zoxide`, `atuin`, `direnv`, and Git tooling are available in the shell.
5. Work happens inside Git worktrees instead of long-lived branch switching in a single checkout.

## Starting work

Typical start-of-day flow:

```bash
cd ~/dev
z some-repo
git worktree list
```

If you are using a Worktree helper that exposes `wt`, the shell config initializes it when present. That tool can sit on top of the same Git worktree workflow, but the baseline documented here is standard `git worktree`.

## Recommended Git worktree flow

For a new task:

```bash
cd ~/dev/my-repo
git fetch origin
git worktree add ../my-repo-feature -b feature/my-change origin/main
cd ../my-repo-feature
```

For an existing branch:

```bash
cd ~/dev/my-repo
git worktree add ../my-repo-bugfix bugfix/some-issue
cd ../my-repo-bugfix
```

To see active worktrees:

```bash
git worktree list
```

To remove a finished worktree:

```bash
git worktree remove ../my-repo-feature
git worktree prune
```

## Shell tools in the loop

- Use `z repo-name` to jump between repositories or worktrees quickly.
- Use `Ctrl-R` for Atuin history search.
- Use `direnv allow` after creating or changing a project `.envrc`.
- Use `ff pattern` for quick file lookup.
- Use `ll` and `lt` for richer directory views when `eza` is installed.

## Review loop

Inside a worktree, the usual review loop is:

```bash
git status
git diff
git add -p
git commit
```

`delta` is the default pager, so diffs and patch review should already render in the improved format.

## Session layout

A practical tmux layout for worktrees is:

- window 1: current feature worktree
- window 2: tests or long-running dev server
- window 3: main branch checkout for comparison or cherry-picking

The important point is to keep branch-specific work isolated in separate worktrees instead of rebasing mental state inside a single checkout.
