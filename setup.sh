#!/bin/sh

# Find out the location in which the dotfiles are located and save it in a file
dotfiles=$(dirname $(dirname $(realpath $0))) &&
echo $dotfiles > $dotfiles/DOTFILES &&

# Ask whether user wants to replace configuration.nix
configName=configuration.nix &&
config=/etc/nixos/$configName &&
dotfilesConfig=$dotfiles/$configName &&
# $1: config
# $2: dotfilesConfig
function replaceConfig {
    rm -f $1 &&
    ln -s $2 $1 &&
    chown root:root $1 &&
    chown root:root $2 &&
    chmod 666 $1 &&
    nixos-rebuild switch
} &&

mkSymlink=true &&
while true
do
    read -r -p "Do you want to replace $config with a \
symlink to the version in this repository? (Requires superuser \
privileges) [Yn] " response &&
    case "$response" in
        [yY][eE][sS]|[yY]|"")
            echo Replacing /etc/nixos/configuration.nix...
            decl=`declare -f replaceConfig`
            sudo bash -c "$decl; replaceConfig $config $dotfilesConfig"
            break;;
        [nN][oO]|[nN]*)
            echo Continuing without replacing /etc/nixos/configuration.nix...
            break;;
    esac
done &&

# Install home-manager
hmPath="https://github.com/rycee/home-manager/archive/release-18.03.tar.gz"

# Run home-manager to set up config files
/usr/bin/env home-manager -f $dotfiles/nixpkgs/home.nix switch
