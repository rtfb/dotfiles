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
alias ripcd='abcde -a cddb,read,encode,tag,move,playlist,clean -o flac -V -x'
alias shutdown='sudo shutdown now'
alias orai='curl wttr.in/vilnius'
alias wttr='curl wttr.in/vilnius'
alias capsesc='setxkbmap -option caps:escape'
alias capslock='xmodmap -e "keycode 0x42 = Caps_Lock"'
