# Dotfiles setup and replication to new machines

## Setup

The following needs to occur in your home `~` directory.

### Set up a bare repo

#### Zsh

    git init --bare $HOME/.dotfiles
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    echo "alias dotfiles config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc

#### Bash

    git init --bare $HOME/.dotfiles
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    echo "alias dotfiles config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc

## Github

Create a github repo, named `dotfiles`

## Set up origin

    dotfiles remote add origin git@github.com:<username>/dotfiles.git

* Replace <username> of course with your github username.

## Usage

You essentially, replace `git` with the alias `dotfiles`:

    dotfiles status
    dotfiles add .gitconfig
    dotfiles commit -m 'Add gitconfig'
    dotfiles push

# Replication to new machine

To replicate your dotfiles to a new machine:

    git clone --separate-git-dir=$HOME/.dotfiles
    https://github.com/<username>/dotfiles.git dotfiles-tmp
    rsync --recursive --verbose --exclude '.git' dotfiles-tmp/ $HOME/
    rm --recursive dotfiles-tmp

And of course, if set up your aliases / origin again (if you plan to push changes from
there):

    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    echo "alias dotfiles config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
    dotfiles remote add origin git@github.com:<username>/dotfiles.git
