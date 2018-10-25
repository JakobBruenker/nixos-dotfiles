{ pkgs, ...}:

with import <nixpkgs> {};
with builtins;

let
  dotfiles = "nixos-dotfiles";
  # read this from a file

in
  {
    # packages:
    # feh
    # pavucontrol
    # discord

    programs.git = {
      enable = true;
      userName = "Jakob Brünker";
      userEmail = "jakob.bruenker@gmail.com";
    };

    programs.firefox = {
      enable = true;
    };

    # hm, I'm not sure how much I really like home manager since you can only
    # configure some programs with it and not others
    # Aaaand I take that back I literally have a page open where it says "even
    # for programs for which home manager doesn't have configuration options, you
    # can use it to manage your dotfiles, e.g.
    # home.file.".config/i3blocks/config".source = "${my-dotfile-dir}/i3blocks.conf"
    # "
    # would it make *any* sense at all to write this?
    # home.file.".config/nixpkgs/home.nix".source = "${my-dotfile-dir}/home.nix"
    # I think it just might, because that means you just have to run
    # home-manager -f dotfiles/home.nix
    # and then you don't have to worry about it from then on
    # unless of course they have an option for it already
    # doesn't really look like it though

    home.file = {
      ".config/nixpkgs/" = {
        source = "/home/user/nixos-dotfiles/nixpkgs";
        recursive = true;
      };
    };
  }
