{ pkgs, ...}:

with import <nixpkgs> {};
with builtins;

let
  dotfiles = replaceStrings ["\n"] [""] (readFile ../DOTFILES);

  configDir = ".config";

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
    home.packages = with pkgs; [
      discord
      dmenu
      feh
      fira-code
      home-manager
      lxqt.qterminal
      ncdu
      neovim
      pavucontrol
      thefuck
      tree
      xclip
      xxd
      zathura
    ];

    programs.git = {
      enable = true;
      userName = "Jakob Brünker";
      userEmail = "jakob.bruenker@gmail.com";
    };

    programs.firefox = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
      dotDir = "${configDir}/zsh";
      shellAliases = {
        vim = "nvim";
        vi = "vim";
        vito = "vim TODO.qt";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        cd- = "cd -";
        cdd = "popd";
        df = "df -h";
        mem = "free -h";
        t = "date | sed -r ''s/(\\w+ ){3}(\\w+:\\w+):\\w+( \\w+){2}/\\2/''";
        h = "hoogle";
        pl = "pointfree";
        p = "xclip -o";
        y = "xclip";
        yy = "mpv $(p) --fs --volume=70 --save-position-on-quit";
        yyl = "yy --ytdl-format=136+bestaudio";
        term = "qterminal > /dev/null 2>&1 &";
        formats = "youtube-dl $(p) -F";
        ys = "mpsyt /";

        gd = "git diff";
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gcm = "git commit -m";
        gpl = "git pull";
        gps = "git push";
        gplo = "git pull origin";
        gpso = "git push origin";
        us = "setxkbmap us";
        de = "setxkbmap de";

        vh = "nvim ${dotfiles}/nixpkgs/home.nix";
        hs = "home-manager switch";
      };
      enableCompletion = true;
      enableAutosuggestions = true;
      history = {
        ignoreDups = true;
        expireDuplicatesFirst = false;
        extended = false;
        share = true;
      };
      sessionVariables = {
        LS_COLORS = "di=33:ln=target:ex=35:fi=34";
        DEFAULT_USER = "user";
      };
      initExtra = ''
        # vim editing mode
        bindkey -v

        # `dir` := `cd dir`
        setopt AUTO_CD

        # cd := pushcd
        setopt AUTO_PUSHD

        # globbing stuff
        setopt GLOB_COMPLETE
        setopt PUSHD_MINUS
        setopt GLOB_STAR_SHORT

        # silent pushd
        setopt PUSHD_SILENT

        # `pushd` goes to ~
        setopt PUSHD_TO_HOME

        # ignores multiple duplicate pushd entries
        setopt PUSHD_IGNORE_DUPS

        # waits 10 seconds when you type `rm *`
        setopt RM_STAR_WAIT

        # use magic
        setopt ZLE
        setopt NO_HUP

        # editor
        export EDITOR="nvim"

        # ignore CTRL-D if not in a nix-shell
        if [[ -v IN_NIX_SHELL ]]; then
          setopt NO_IGNORE_EOF
        else
          setopt IGNORE_EOF
        fi

        setopt NO_FLOW_CONTROL
        setopt NO_CLOBBER
        setopt NO_CASE_GLOB
        setopt NUMERIC_GLOB_SORT
        setopt EXTENDED_GLOB

        # setup thefuck
        eval $(thefuck --alias)
      '';
      profileExtra = "";
      loginExtra = "";
      logoutExtra = "";
      plugins = [
        {
          name = "nix-shell";
          src = pkgs.fetchFromGitHub (fromJSON ''
            {
              "owner": "chisui",
              "repo": "zsh-nix-shell",
              "rev": "dceed031a54e4420e33f22a6b8e642f45cc829e2",
              "sha256": "10g8m632s4ibbgs8ify8n4h9r4x48l95gvb57lhw4khxs6m8j30q"
            }
          '');
        }
        {
          name = "nix";
          src = pkgs.fetchFromGitHub (fromJSON ''
            {
              "owner": "spwhitt",
              "repo": "nix-zsh-completions",
              "rev": "13a5533b231798c2c8e6831e00169f59d0c716b8",
              "sha256": "1xa1nis1pvns81im15igbn3xxb0mhhfnrj959pcnfdcq5r694isj"
            }
          '');
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
        ];
        custom = "$HOME/${configDir}/oh-my-zsh-custom";
        theme = "agnoster-nix";
      };
    };

    home.file = concatSets (
      # Files whose content is specified here
      [
        {
          # start zsh, and exit if zsh is exited
          ".bashrc".text = ''
            zsh
            exit
          '';
        }
      ] ++

      # Directories in .config
      linkDirs "${configDir}/" [
        "nixpkgs"
        "mpv"
        "youtube-dl"
        "qterminal.org"
        "nvim"
        "customvimstuff"
        "oh-my-zsh-custom"
      ] ++

      # Files in .config
      linkFiles "${configDir}/" [
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
