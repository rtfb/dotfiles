
if [ -d ~/sw/go ]; then
    export GOROOT=~/sw/go
fi

if [ -d ~/hacking/go ]; then
    export GOROOT=~/hacking/go
fi

export GOPATH=~/sw/gopkgs
export GOBIN=$GOPATH/bin

CDPATH=$CDPATH:$GOPATH/src/github.com:$GOPATH/src/code.google.com/p:$GOPATH/src/bitbucket.org

PATH=$HOME/sw/nodejs/bin:${PATH}
PATH=$HOME/sw/gradle-1.7/bin:${PATH}
PATH=$GOPATH/bin:${PATH}
PATH=$GOROOT/bin:${PATH}
PATH=$HOME/bin:${PATH}

export PATH
export EDITOR=vim
export NDKROOT=$HOME/sw/android-ndk-r9b

if [ "$0" = "/usr/sbin/lightdm-session" -a "$DESKTOP_SESSION" = "i3" ]; then
    export $(gnome-keyring-daemon --start --components=ssh)
fi

eval "$(ssh-agent -s)"
