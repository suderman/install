#!/bin/sh

# 2014 Jon Suderman
# https://github.com/suderman/install/

# Open a terminal and run this command:
# curl https://raw.github.com/suderman/install/master/tmux | sh

# dotfiles and prefix directory
DOTFILES=$HOME/.dotfiles

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
    # https://github.com/suderman/osx
    $HOME/.osx/bin/launchup
  }
  ;;

  # Ubuntu
  Linux ) command -v $HOME/.linuxbrew/bin/tmux >/dev/null 2>&1 || {
    echo "Installing tmux on Ubuntu"

    # Ensure homebrew has been installed
    curl -sS https://raw.github.com/suderman/install/master/homebrew | sh

    # Install with homebrew
    brew install tmux

    # Make useable pasteboard for remote sessions from OS X to Linux
    # Check ssh/config, ~/Library/LaunchAgents, and tmux.conf  
    # https://gist.github.com/burke/5960455
  }
  ;;
esac

