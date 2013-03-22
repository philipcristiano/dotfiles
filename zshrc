export EDITOR="mvim -v"
export ZSH=~/config/oh-my-zsh
export CONFIG_DIR=~/config

source $CONFIG_DIR/zsh/gitstatus.zsh
#export PS1=$"%{\e[1;31m%}%B[%~] %%%b%{\e1;00m%}"

export PROMPT=$'%{\e[1;31m%}%m $(git_super_status) [%~] %%%b% %{\e[1;00m%} '

# alias
alias va="source bin/activate"
alias rake="noglob rake"
alias xcurl='curl -H Content-Type:\ application/json'
alias dirsize='du -s * | sort -n | cut -f 2- | while read a; do du -hs "$a"; done;'
alias sg_clean_cache='rm -rf ~/Sites/tixcast/cache/*'
alias listingfeed='cd ~/Sites/tixcast/services/listingfeed; source ~/Sites/tixcast/virtualenvs/listingfeed/bin/activate'
alias api='cd ~/Sites/tixcast/services/api; source ~/Sites/tixcast/virtualenvs/api/bin/activate'
alias santamaria='cd ~/Sites/tixcast/services/santamaria; source ~/Sites/tixcast/virtualenvs/santamaria/bin/activate'
alias git merge='git merge --no-ff'


function work_on {
    ~/Sites/tixcast/services/$1
    source ~/Sites/tixcast/virtualenvs/$1/bin/activate
}

# completion
export FPATH=$FPATH:~/config/completions:$ZSH/functions
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

export GREP_OPTIONS="--color=auto"

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

source ~/config/oh-my-zsh/plugins/gem/gem.plugin.zsh
source ~/config/oh-my-zsh/plugins/git/git.plugin.zsh
source ~/config/oh-my-zsh/plugins/macports/macports.plugin.zsh
source ~/config/oh-my-zsh/plugins/pip/pip.plugin.zsh
source ~/config/oh-my-zsh/plugins/vagrant/vagrant.plugin.zsh
