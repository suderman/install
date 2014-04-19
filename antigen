#!/bin/sh

# 2014 Jon Suderman
# https://github.com/suderman/install/

# Open a terminal and run this command:
# curl https://raw.github.com/suderman/install/master/antigen | sh

# antigen directory
ANTIGEN=$HOME/.antigen

# Check if the directory exists
if [ -d $ANTIGEN ]; then

  # Now check if it's a git repo
  if [ -d $ANTIGEN/.git ]; then

    # It is? Great, let update it!
    echo "Updating antigen..."
    cd $ANTIGEN && git pull

  # It's not? Rename it so we can install this one
  else
    echo "Backing up existing $ANTIGEN to make room for the new one!"
    mv $ANTIGEN $ANTIGEN.backup
  fi
fi

# Check for and install antigen
if [ ! -d $ANTIGEN ]; then

  # Ensure git exists
  curl -sS https://raw.github.com/suderman/install/master/git | sh

  # Clone antigen into the home directory
  echo "Installing antigen..."
  git clone https://github.com/zsh-users/antigen.git $ANTIGEN

fi

