#!/bin/sh

# 2014 Jon Suderman
# https://github.com/suderman/install/

# Open a terminal and run this command:
# curl https://raw.github.com/suderman/install/master/tmux | sh

# dotfiles and prefix directory
DOTFILES=$HOME/.dotfiles
PREFIX=$HOME/local

# Is this OS X or Ubuntu? 
case "`uname`" in
  
  # OS X 
  Darwin ) command -v /usr/local/bin/tmux >/dev/null 2>&1 || {
    echo "Installing tmux on OS X"

    # Ensure homebrew has been installed
    curl -sS https://raw.github.com/suderman/install/master/homebrew | sh

    # Install with homebrew
    brew install tmux
    brew install reattach-to-user-namespace
    
    # Install launch agents for remote copy paste
    # https://gist.github.com/burke/5960455
    LAUNCH=$HOME/Library/LaunchAgents

    # Fix permissions so launchctl doesn't complain
    chmod go-rw $DOTFILES/osx/LaunchAgents/*

    # Symlink from the dotfiles
    ln -sf $DOTFILES/osx/LaunchAgents/local.pbcopy.plist $LAUNCH
    ln -sf $DOTFILES/osx/LaunchAgents/local.pbpaste.plist $LAUNCH

    # Load them right now
    launchctl load $LAUNCH/local.pbcopy.plist
    launchctl load $LAUNCH/local.pbpaste.plist
  }
  ;;

  # Ubuntu
  Linux ) command -v $PREFIX/bin/tmux >/dev/null 2>&1 || {
    echo "Installing tmux on Ubuntu"

    # Ensure libevent has been installed
    curl https://raw.github.com/suderman/install/master/libevent | sh

    # Ensure ncurses has been installed
    curl https://raw.github.com/suderman/install/master/ncurses | sh

    # Make tmp directory and change into it
    mkdir -p /tmp/tmux && cd /tmp/tmux

    # Download the source
    curl -L https://dl.dropbox.com/s/4oyzapfs106d7os/tmux-1.9a.tar.gz > /tmp/tmux.tar.gz

    # Extract the contents into our tmp directory
    tar -xv --file=/tmp/tmux.tar.gz --strip-components=1 --directory=/tmp/tmux
    
    # Configure tmux and build it
    ./configure --enable-static CFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-L$PREFIX/lib -L$PREFIX/include -L$PREFIX/include/ncurses" LIBEVENT_CFLAGS="-I$PREFIX/include" LIBEVENT_LIBS="-L$PREFIX/lib -levent"
    make -j5
    cp tmux $PREFIX/bin

    # Make useable pasteboard for remote sessions from OS X to Linux
    # Check ssh/config, ~/Library/LaunchAgents, and tmux.conf  
    # https://gist.github.com/burke/5960455

    # Ensure local bin exists
    mkdir -p $PREFIX/bin && cd $PREFIX/bin
    
    # Write scripts and make executable
    echo '#!/bin/sh\ncat | nc -q1 localhost 2224\n' > pbcopy
    echo '#!/bin/sh\nnc localhost 2225\n' > pbpaste
    chmod a+x pbcopy
    chmod a+x pbpaste
  }
  ;;
esac

