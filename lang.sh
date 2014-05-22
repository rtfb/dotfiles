#!/bin/sh

if [ $# -eq 0 ] ; then
    setxkbmap us
else
    if [ $1 = "ru" ] ; then
        setxkbmap ru phonetic
    else
        setxkbmap $1
    fi
fi

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
