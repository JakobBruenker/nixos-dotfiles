#!/bin/sh

# Find out the location in which the dotfiles are located and save it in a file
export DOTFILES=$(dirname $(dirname $(realpath $0)))
echo $DOTFILES > $DOTFILES/.DOTFILES

/usr/bin/env home-manager -f $DOTFILES/nixpkgs/home.nix switch
