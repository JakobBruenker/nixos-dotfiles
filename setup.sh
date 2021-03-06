#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash home-manager coreutils

# Find out the location in which the dotfiles are located and save it in a file
dotfiles=$(dirname $(realpath $0)) &&
echo $dotfiles > $dotfiles/DOTFILES &&

# Ask whether user wants to replace configuration.nix
confDir=nixpkgs
configName=configuration.nix &&
config=/etc/nixos/$configName &&
dotfilesConfig=$dotfiles/$confDir/$configName &&
customHardware=$dotfiles/$confDir/custom-hardware.nix &&

function replaceConfig {
    config=$1
    dotfilesConfig=$2
    customHardware=$3
    rm -f $config
    printf "\
{ config, pkgs, ... }: \n\
{\n\
  imports =\n\
    [ # Include the results of the hardware scan.\n\
      ./hardware-configuration.nix\n\
      # Include the configuration in the user directory.\n\
      $dotfilesConfig\n\
      # Include the hardware configuration in the user directory.\n\
      $customHardware\n\
    ];\n\
}\n" > $config
    nixos-rebuild switch
} &&

ret=0
while true
do
    echo Do you want to replace $config?
    read -r -p "(Requires superuser privileges, and sudo must be installed)\
 [Yn] " response &&
    case "$response" in
        [yY][eE][sS]|[yY]|"")
            echo Replacing $config...
            sudo bash -c "`declare -f replaceConfig`;\
                          replaceConfig $config $dotfilesConfig $customHardware"
            ret=$?
            break;;
        [nN][oO]|[nN]*)
            echo Continuing without replacing $config...
            break;;
    esac
done &&

if [ $ret != 0 ]; then
    echo Replacing $config failed with exit code $ret
    exit 1
else
    # Run home-manager to set up config files
    home-manager -f $dotfiles/nixpkgs/home.nix switch
fi
