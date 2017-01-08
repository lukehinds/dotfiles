# https://github.com/lukehinds/dotfiles

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
# Path to your oh-my-zsh installation.
  export ZSH=/home/luke/.oh-my-zsh

# Set theme

if [[ -z "$INSIDE_EMACS" ]]; then
    # normal term
    ZSH_THEME="agnoster"
else
    # inside Emacs
    ZSH_THEME="dpoggi"
fi

# Plugins

plugins=(git z glassfish)
# User configuration

source $ZSH/oh-my-zsh.sh
export TERM=xterm-256color
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:~/.cargo/bin:~/bin:/usr/sbin"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Aliases
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias backup="/usr/bin/rsync --exclude-from='excludes.txt' --delete -avh /home/luke/ lhinds@cube:/home/lhinds/rh_backup"
alias pacup="sudo pacman -Syu"
alias chknet="~/bin/chknet.sh"
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
fi

alias dotfiles config='/usr/bin/git --git-dir=/home/luke/.dotfiles/ --work-tree=/home/luke'

# Systemctl
alias sdisable=' sudo systemctl disable $@'
alias senable='sudo systemctl enable $@'
alias srestart='sudo systemctl restart $@'
alias sstart='sudo systemctl start $@'
alias sstatus='sudo systemctl status $@'

# virtualenvwrapper

source /usr/bin/virtualenvwrapper.sh
