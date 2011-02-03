export EDITOR=vim
export ZSH=~/config/oh-my-zsh
#export PS1=$"%{\e[1;31m%}%B[%~] %%%b%{\e1;00m%}"

export PROMPT=$'%{\e[1;31m%}%m [%~] %%%b% %{\e[1;00m%} '

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

alias svns="svn status | grep -v \"^[X|Performing|$]\""


###
#
# oh-my-zshell
#
###

source ~/config/oh-my-zsh/plugins/vagrant/vagrant.plugin.zsh
source ~/config/oh-my-zsh/plugins/pip/pip.plugin.zsh
source ~/config/oh-my-zsh/plugins/git/git.plugin.zsh
source ~/config/oh-my-zsh/plugins/macports/macports.plugin.zsh

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
#for config_file ($ZSH/lib/*.zsh) source $config_file

# Load all of your custom configurations from custom/
#for config_file ($ZSH/custom/*.zsh) source $config_file

# Load all of the plugins that were defined in ~/.zshrc
#plugin=${plugin:=()}
#for plugin ($plugins) source $ZSH/plugins/$plugin/$plugin.plugin.zsh

# Load the theme
#source "$ZSH/themes/$ZSH_THEME.zsh-theme"

# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" = "true" ]
then
  return
else
  /usr/bin/env zsh $ZSH/tools/check_for_upgrade.sh
fi
