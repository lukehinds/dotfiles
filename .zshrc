# https://github.com/lukehinds/dotfiles
export TERM="xterm-256color"

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
# Path to your oh-my-zsh installation.
  export ZSH=/home/luke/.oh-my-zsh

# Set theme

if [[ -z "$INSIDE_EMACS" ]]; then
    # normal term
    ZSH_THEME="powerlevel9k/powerlevel9k"
else
    # inside Emacs
    ZSH_THEME="dpoggi"
fi

# Taskwarrior prompt
export PS1='$(task +in +PENDING count) '$PS1

# Plugins

plugins=(git z glassfish)

# User configuration

# Up function
# "up" to "cd ..", or I can run "up 4" to "cd ../../../.."

function up {
    if [[ "$#" < 1 ]] ; then
        cd ..
    else
        CDSTR=""
        for i in {1..$1} ; do
            CDSTR="../$CDSTR"
        done
        cd $CDSTR
    fi
}

source $ZSH/oh-my-zsh.sh

# Exports
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export XDG_CONFIG_DIRS=~/.config
export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:~/.cargo/bin:~/bin:/usr/sbin:~/.gem/ruby/2.4.0/bin"
export VISUAL="nvim"
export GOPATH=~/repos/go
export PATH="$PATH:$GOPATH/bin"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='mvim'
fi

# Aliases
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias backup="/usr/bin/rsync --exclude-from='excludes.txt' --delete -avh /home/luke/ lhinds@cube:/home/lhinds/rh_backup"
alias pacup="sudo pacman -Syu"
alias chknet="~/bin/chknet.sh"
alias gitstat="~/bin/gitstat.sh"
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias x="exit"
alias g="git"
alias gs='git status'
alias gd='git diff'
alias g-='git checkout -'
alias serve='python -m SimpleHTTPServer 8000'

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
fi

# Systemctl
alias sdisable=' sudo systemctl disable $@'
alias senable='sudo systemctl enable $@'
alias srestart='sudo systemctl restart $@'
alias sstart='sudo systemctl start $@'
alias sstatus='sudo systemctl status $@'


alias vpn='nmcli --ask con $1 $2'

# Taskwarrior
alias t='task'
alias in='task add +in'
alias td='task done $@'
alias ts='task start $@'

# virtualenvwrapper

source /usr/bin/virtualenvwrapper.sh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#source /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
