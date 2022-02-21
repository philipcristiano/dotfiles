export ZSH=~/config/oh-my-zsh
export SUPPRESS_GETEXL=True
export CONFIG_DIR=~/dotfiles


# Add things if we are not already in a nix shell
if [[ -v IN_NIX_SHELL ]]; then
    # Seems like we're in a nix shell
else
    # Seems we are not in a nix shell
    if [[ -a /Users/philipcristiano/.nix-profile/etc/profile.d/nix.sh ]]; then
        source /Users/philipcristiano/.nix-profile/etc/profile.d/nix.sh
    fi
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix

    export PATH="/Applications/MacVim.app/Contents/bin:/home/$USER/bin:$PATH"
fi

if hash mvim 2>/dev/null; then
    export EDITOR="mvim -v"
else
    export EDITOR="vim"
fi

## Allow dynamic prompts
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# Set the prompt formatting
export PROMPT=$'%{\e[1;31m%}%m $SHLVL [%~] %%%b% %{\e[1;00m%} '

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
      nix-shell --run "zsh -i"
    else
      start_dev
    fi
  fi
}

function start_dev {
  if [ -r ".env" ]; then
      echo ".env"
      source ".env"
  else
      echo ".env not found"
  fi
}

# completion
export FPATH=$FPATH:~/dotfiles/completions:$ZSH/functions
autoload -U compinit
compinit

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
