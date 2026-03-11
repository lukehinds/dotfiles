# Tmux Cheat Sheet

Prefix key: `Ctrl-A`

## Windows (tabs)

| Keys | Action |
|------|--------|
| `Prefix + c` | Kill current pane |
| `Prefix + Ctrl-C` | New window |
| `Prefix + H` | Previous window |
| `Prefix + L` | Next window |
| `Prefix + Ctrl-A` | Last window |
| `Prefix + r` | Rename window |
| `Prefix + w` | List windows |
| `Prefix + "` | Choose window |

## Panes (splits)

| Keys | Action |
|------|--------|
| `Prefix + \|` | Split vertical |
| `Prefix + s` | Split horizontal |
| `Prefix + v` | Split vertical (alt) |
| `Prefix + h` | Select pane left |
| `Prefix + j` | Select pane down |
| `Prefix + k` | Select pane up |
| `Prefix + l` | Select pane right |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + x` | Swap pane down |
| `Prefix + ,` | Resize pane left |
| `Prefix + .` | Resize pane right |
| `Prefix + -` | Resize pane down |
| `Prefix + =` | Resize pane up |

## Sessions

| Keys | Action |
|------|--------|
| `Prefix + S` | Choose session |
| `Prefix + o` | SessionX (fuzzy session picker) |
| `Prefix + Ctrl-D` | Detach |

## Plugins

| Keys | Action |
|------|--------|
| `Prefix + p` | Floax (floating pane) |
| `Prefix + Ctrl-s` | Save session (resurrect) |
| `Prefix + Ctrl-r` | Restore session (resurrect) |
| `Prefix + I` | Install plugins (TPM) |
| `Prefix + U` | Update plugins (TPM) |

## Copy Mode (vi keys)

| Keys | Action |
|------|--------|
| `Prefix + [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Yank selection (tmux-yank) |
| `q` | Exit copy mode |

## Other

| Keys | Action |
|------|--------|
| `Prefix + R` | Reload config |
| `Prefix + Ctrl-L` | Refresh client |
| `Prefix + K` | Clear pane |
| `Prefix + *` | Sync panes (type in all) |
| `Prefix + :` | Command prompt |
