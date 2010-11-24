export EDITOR=vim
#export PS1=$"%{\e[1;31m%}%B[%~] %%%b%{\e1;00m%}"


export GREP_OPTIONS="--color=auto"
export PROMPT=$'%{\e[1;31m%}%m [%~] %%%b% %{\e[1;00m%} '


# completion
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
