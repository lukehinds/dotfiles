# Redirect shell state into TMPDIR when HOME is sandboxed and not writable.
if [[ -n "${CODEX_SANDBOX:-}" ]]; then
  export XDG_CACHE_HOME="${TMPDIR:-/tmp}/zsh-cache-${USER}"
  export XDG_STATE_HOME="${TMPDIR:-/tmp}/zsh-state-${USER}"
  export HISTFILE="${TMPDIR:-/tmp}/.zsh_history-${USER}"
  export ZSH_COMPDUMP="${XDG_CACHE_HOME}/.zcompdump-${HOST%%.*}-${ZSH_VERSION}"
  export FNM_MULTISHELL_PATH="${TMPDIR:-/tmp}/fnm_multishells"

  mkdir -p "${XDG_CACHE_HOME}" "${XDG_STATE_HOME}" "${FNM_MULTISHELL_PATH}"
fi

# -----------------------------
# Completions
# -----------------------------
autoload -Uz compinit && compinit

# -----------------------------
# Zsh plugins (sourced directly)
# -----------------------------
ZSH_PLUGIN_DIRS=(
  "$HOME/.zsh/plugins"
  "/opt/homebrew/share"
  "/usr/share/zsh/plugins"
  "/usr/local/share"
)

_source_plugin() {
  local name="$1"
  for dir in "${ZSH_PLUGIN_DIRS[@]}"; do
    if [[ -f "$dir/$name/$name.plugin.zsh" ]]; then
      source "$dir/$name/$name.plugin.zsh"; return
    elif [[ -f "$dir/$name/$name.zsh" ]]; then
      source "$dir/$name/$name.zsh"; return
    fi
  done
}

_source_plugin zsh-autosuggestions
_source_plugin zsh-syntax-highlighting
_source_plugin fast-syntax-highlighting

# -----------------------------
# OS Detection
# -----------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  IS_MACOS=1
else
  IS_MACOS=0
fi

# -----------------------------
# Core Tools
# -----------------------------
export GPG_TTY=$(tty)
[[ $IS_MACOS -eq 1 ]] && export HOMEBREW_NO_ENV_HINTS=1

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# atuin - shell history search
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# zoxide - smarter directory jumping
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  [[ -f ~/.term/zsh-z.plugin.zsh ]] && source ~/.term/zsh-z.plugin.zsh
fi

# starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# -----------------------------
# Dev Tools (guarded per-machine)
# -----------------------------

# Go
if [[ -d "$HOME/go/bin" ]]; then
  export GOBIN="$HOME/go/bin"
  export PATH="$GOBIN:$PATH"
fi

# Pyenv
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# fnm (Fast Node Manager)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

# npm global bin (only if npm exists)
command -v npm &>/dev/null && export PATH="$(npm bin -g):$PATH"

# gvm (Go Version Manager)
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# LM Studio
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# Antigravity
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# OpenClaw
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# Homebrew (macOS: /opt/homebrew, Linux: /home/linuxbrew)
if [[ $IS_MACOS -eq 1 ]]; then
  [[ -d "/opt/homebrew/sbin" ]] && export PATH="/opt/homebrew/sbin:$PATH"
else
  [[ -d "/home/linuxbrew/.linuxbrew/bin" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# HF CLI / local bin
export PATH="$PATH:$HOME/.local/bin"

# rust/cargo env
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# -----------------------------
# Aliases
# -----------------------------
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias x="exit"

# Git Operations
alias g="git"
alias gs='git status'
alias gd='git diff'
alias g-='git checkout -'
alias gpm='git pull origin main'
alias gl='git log --oneline'

# vim
alias vi='nvim'
alias vim='nvim'

alias python='python3'
alias nvm='fnm'
alias cve='unset VIRTUAL_ENV && hash -r'
alias killpy='lsof -ti:8000 | xargs kill -9 2>/dev/null || true'
alias chrome='open -a "Google Chrome"'
command -v fd &>/dev/null && alias ff='fd --hidden --exclude .git'

# bat (only if installed)
command -v bat &>/dev/null && alias cat='bat --style=plain --paging=never'
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias l='eza --group-directories-first --icons=auto'
  alias ll='eza -lah --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --group-directories-first --icons=auto'
fi

# worktunk
alias wl='wt list'
alias wc='wt step commit'
alias wtm='wt switch main'
wtt() { wt switch -c "$1"; }
wd() { wt remove -D "$1"; }


# cargo/nono
command -v cargo &>/dev/null && alias nn='cargo run --'

# nono sandbox wrapper for claude
command -v nono &>/dev/null && sclaude() { nono run --profile claude-code "$@" -- claude; }

# -----------------------------
# Functions
# -----------------------------

# macOS-only functions
if [[ $IS_MACOS -eq 1 ]]; then
  # Sign a file using minisign key stored in macOS Keychain
  sign-file() {
    local pass
    pass=$(security find-generic-password -s "minisign-key-pass" -w)
    echo "$pass" | minisign -S -m "$1"
  }

  # sudo with Touch ID support
  sudo() {
    if [ -t 0 ]; then
      /usr/bin/sudo "$@"
    else
      /usr/bin/sudo -S "$@" < <(touchkey)
    fi
  }
fi

# -----------------------------
# Local overrides (not in repo)
# -----------------------------
[[ -f "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"

# -----------------------------
# Dotfiles update checker
# -----------------------------
DOTFILES_DIR="$(dirname "$(readlink -f "${HOME}/.zshrc")" 2>/dev/null)/.."
[[ -f "$DOTFILES_DIR/zsh/update.zsh" ]] && source "$DOTFILES_DIR/zsh/update.zsh"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# direnv should load as late as possible.
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"


claude() {
  command nono run --profile claude-code --allow-cwd -- /Users/lukehinds/.local/bin/claude "$@"
}

codex() {
  command nono run --profile codex --allow-cwd -- /Users/lukehinds/.local/state/fnm_multishells/17028_1773508819414/bin/codex "$@"
}
