{ pkgs, ...}:

with import <nixpkgs> {};
with builtins;

let
  dotfiles = replaceStrings ["\n"] [""] (readFile ../DOTFILES);

  linkDir = name: {
    ".config/${name}" = {
        source = "${dotfiles}/${name}";
        recursive = true;
      };
    };

  linkFile = name: { ".config/${name}".source = "${dotfiles}/${name}"; };

  concatSets = foldl' (x: y: x // y) {};

in
  {
    home.packages = [
      pkgs.feh
      pkgs.pavucontrol
      pkgs.discord
      pkgs.fira-code
      pkgs.lxqt.qterminal
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
      map linkDir [
        "nixpkgs"
        "mpv"
	"qterminal.org"
      ] ++
      map linkFile [
        "DOTFILES"
      ]
    );
  }
