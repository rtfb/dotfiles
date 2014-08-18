# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

platform="unknown"
unamestr=$(uname)

case "$unamestr" in
    "Linux")
        platform="linux"
        ;;
    "Darwin")
        platform="osx"
        ;;
    *)
        echo "Unknown platform uname '$unamestr', exiting..."
        exit
        ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
if [[ $platform == "osx" ]]; then
    alias ls='ls -G'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias du='du -kh'
case "$platform" in
    "osx")
        alias df='df -H'
        ;;
    "linux" | "")
        alias df='df -kTh'
        ;;
esac

alias ..='cd ..'
alias ...='cd ../..'
alias xs='cd'
alias vf='cd'
alias ppjson='xclip -o | python -mjson.tool'
alias wip='git ci -a -mWIP'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export GOROOT=~/hacking/go
export GOPATH=~/sw/gopkgs

PATH=$HOME/sw/nodejs/bin/:$HOME/sw/gradle-1.7/bin:$GOROOT/bin:${PATH}

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

export PATH
export EDITOR=vim
export NDKROOT=$HOME/sw/android-ndk-r9b

case "$platform" in
    "linux")
        export ANDROID_HOME=$HOME/sw/android-sdk-linux
        ;;
    "osx")
        export ANDROID_HOME=$HOME/sw/android-sdk-macosx
        ;;
    "win")
        export ANDROID_HOME=/e/sw/android-sdk/
        ;;
    *)
        echo "WARNING: Unknown platform '$platform', ANDROID_HOME not set."
        ;;
esac

case $(hostname) in
    "dungeon")
        export MUSIC_DIR=$HOME/Muzika
        ;;
    "vsaltenis")
        export MUSIC_DIR=/media/rtfb/Data/music/
        ;;
esac

if [[ $platform == 'linux' ]]; then
    if [ -f /etc/bash_completion.d/git ]; then
        source /etc/bash_completion.d/git
    else
        source /etc/bash_completion.d/git-prompt
    fi
fi

Color_Off="\[\033[0m\]"       # Text Reset
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
BYellow="\[\033[1;33m\]"      # Yellow
Time12h="\T"
Time24h="\t"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"
GIT_PS1_SHOWDIRTYSTATE="1"
GIT_PS1_SHOWUNTRACKEDFILES="1"
GIT_PS1_SHOWSTASHSTATE="1"
#  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
if [[ $platform == 'linux' ]]; then
    export PS1=$Blue$Time24h$Color_Off'$(git branch &>/dev/null;\
    if [ $? -eq 0 ]; then \
      echo "$( \
      if [ "$(__git_ps1 %s)" = "`git branch | grep "*" | sed s/"^* "//`" ]; then \
        # @4 - Clean repository - nothing to commit
        echo "'$Green'"$(__git_ps1 " (%s)"); \
      else \
        # @5 - Changes to working tree
        echo "'$IRed'"$(__git_ps1 " (%s)"); \
      fi) '$BYellow$PathShort$Color_Off'\$ "; \
    else \
      # @2 - Prompt when not in GIT repo
      echo " '$Yellow$PathShort$Color_Off'\$ "; \
    fi)'
else
    export PS1=$Blue$Time24h$Color_Off" $Yellow$PathShort$Color_Off\$ "
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Found here: http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
function cbhs() {
    local num_lines=1
    if [ $# -gt 0 ] ; then num_lines=$1; fi
    cat $HISTFILE | tail -n $num_lines | cb
}
