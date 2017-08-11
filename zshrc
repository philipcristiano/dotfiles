export EDITOR="mvim -v"
export ZSH=~/config/oh-my-zsh
export SUPPRESS_GETEXL=True
export CONFIG_DIR=~/dotfiles

# Add Nix only if we are not already in a nix shell
if [[ "$IN_NIX_SHELL" != 1 ]]
then
  source /Users/philipcristiano/.nix-profile/etc/profile.d/nix.sh
fi

source $CONFIG_DIR/zsh/gitstatus.zsh
#export PS1=$"%{\e[1;31m%}%B[%~] %%%b%{\e1;00m%}"
#
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PROMPT=$'%{\e[1;31m%}%m $SHLVL $(git_super_status)[%~] %%%b% %{\e[1;00m%} '

# alias
alias dirsize='du -s * | sort -n | cut -f 2- | while read a; do du -hs "$a"; done;'
alias git merge='git merge --no-ff'
alias git clean-merged-branches='git branch --merged master | \grep -v "master" | xargs -n 1 git branch -d'
alias grep='grep -irn --color=auto'

function work_on {
  if [[ -d ~/gits/$1 ]]; then
    WORK_DIR="${HOME}/gits/${1}"
    cd "${WORK_DIR}"

    # source .env if it exists
    if [ -r "${WORK_DIR}/.env" ]; then
        source "${WORK_DIR}/.env"
    fi
    if [[ -a shell.nix ]]; then
      # execute nix-shell and then start_dev
      echo "Starting Nix Shell"
      nix-shell --run "zsh -ic \"start_dev $1; zsh -i\""
    else
      start_dev "$1"
    fi
  fi
}

function start_dev {
  if [[ -a tox.ini ]]; then
      # Has a tox, we should install reqs with tox but not run tests
      tox --notest
  else
    # Setup a venv with requirements
     if [[ -d ~/virtualenvs/$1 ]]; then
       source ~/virtualenvs/$1/bin/activate
     else
       virtualenv ~/virtualenvs/$1
       source ~/virtualenvs/$1/bin/activate
     fi
     if [[ -a requirements.txt ]]; then
       pip install -r requirements.txt
     fi
  fi

  if [[ -a Gemfile ]]; then
    bundle --path ~/.bundles/$1
  fi
  if [ -r ".env" ]; then
      echo ".env"
  else
      echo ".env not found"
  fi
}

# completion
export FPATH=$FPATH:~/dotfiles/completions:$ZSH/functions
autoload -U compinit
compinit

#Nose Matching
export NOSE_TESTMATCH="((?:^|[b_.-])(:?[Tt]est|When|should|[Dd]escribe))"
export CDPATH="$CDPATH:~:~/gits:~/svn:~/svn/packages"

# correction
setopt correctall

# prompt
autoload -U promptinit
promptinit

export HISTSIZE=2000
export HISTFILE="$HOME/.history"

# (History won't be saved without the following command)
export SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt autocd
setopt extendedglob

#Set title
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac

 ###
# See if we can use colors.

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

###
#
# Key bindings
#
###


bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^?" backward-delete-char # Sometimes OSX/SSH make things difficult
bindkey '^R' history-incremental-search-backward


###
#
# oh-my-zshell
#
###

source ~/dotfiles/oh-my-zsh/plugins/gem/gem.plugin.zsh
source ~/dotfiles/oh-my-zsh/plugins/git/git.plugin.zsh
source ~/dotfiles/oh-my-zsh/plugins/macports/macports.plugin.zsh
source ~/dotfiles/oh-my-zsh/plugins/pip/pip.plugin.zsh
source ~/dotfiles/oh-my-zsh/plugins/vagrant/vagrant.plugin.zsh

###
# SSH
###

# Add Keys if we don't have any
if [[ $SHLVL == 1 ]]; then
  ssh-add -l
  RC=$?
else
  ssh-add -l > /dev/null
  RC=$?
fi

if [[ $RC == 1 ]]; then
  ssh-add -A
fi
