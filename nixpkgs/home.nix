{ pkgs, ...}:

with import <nixpkgs> {};
with builtins;

let
  dotfiles = replaceStrings ["\n"] [""] (readFile ../DOTFILES);

  # must contain a slash at the end
  configDir = ".config/";

  linkLocation = isDir: prefix: name: {
    "${prefix}${name}" = {
      source = "${dotfiles}/${name}";
      recursive = isDir;
      };
    };

  linkLocations = isDir: prefix: map (linkLocation isDir prefix);

  linkDirs = prefix: linkLocations true prefix;

  linkFiles = prefix: linkLocations false prefix;

  concatSets = foldl' (x: y: x // y) {};

in
  {
    home.packages = [
      pkgs.discord
      pkgs.dmenu
      pkgs.feh
      pkgs.fira-code
      pkgs.lxqt.qterminal
      pkgs.neovim
      pkgs.pavucontrol
      pkgs.tree
      pkgs.xxd
      pkgs.zathura
      pkgs.home-manager
    ];

    programs.git = {
      enable = true;
      userName = "Jakob Brünker";
      userEmail = "jakob.bruenker@gmail.com";
    };

    programs.firefox = {
      enable = true;
    };

    home.file = concatSets (
      # Directories in .config
      linkDirs configDir [
        "nixpkgs"
        "mpv"
	"youtube-dl"
        "qterminal.org"
        "nvim"
        "customvimstuff"
      ] ++

      # Files in .config
      linkFiles configDir [
        "DOTFILES"
      ] ++

      # Directories starting with .
      linkDirs "." [
        "xmonad"
        "mozilla"
      ] ++

      # Files starting with .
      linkFiles "." [
      ]
    );
  }
