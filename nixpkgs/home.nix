{ pkgs, ...}:

with import <nixpkgs> {};
with builtins;

let
  dotfiles = lib.fileContents ../DOTFILES;

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
    nixpkgs.config = { allowUnfree = true; };

    home.packages = with pkgs; [
      chromium
      discord
      dmenu
      feh
      fira-code
      home-manager
      keepassx2
      lxqt.qterminal
      mpv
      ncdu
      neovim
      openssl
      p7zip
      pavucontrol
      thefuck
      tree
      unzip
      xclip
      xxd
      youtube-dl
      zathura
      zip
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
        ns = "nix-shell";
        vim = "nvim";
        vi = "vim";
        vito = "vim TODO.qt";
        ipy = "ipython --profile=term";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        cd- = "cd -";
        cdd = "popd";
        df = "df -h";
        mem = "free -h";
        t = "date +%H:%M:%S";
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
        gcd = "cd $(git rev-parse --show-toplevel)";

        us = "setxkbmap us";
        de = "setxkbmap de";

        vh = "nvim ${dotfiles}/nixpkgs/home.nix";
        hs = "home-manager switch";
      };
      enableCompletion = true;
      enableAutosuggestions = false;
      history = {
        ignoreDups = true;
        expireDuplicatesFirst = false;
        extended = false;
        share = true;
      };
      sessionVariables = {
        LS_COLORS = "di=33:ow=33:ln=target:ex=35:fi=34";
        DEFAULT_USER = "user";
      };
      initExtra = ''
        # set character shown for partial lines
        PROMPT_EOL_MARK=↲

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

        # correct spelling errors
        # setopt CORRECT
        # setopt CORRECT_ALL
        setopt DVORAK

        # ignore dups
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_IGNORE_DUPS

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

        # don't put commands into history if they begin with a space
        setopt HIST_IGNORE_SPACE

        setopt NO_FLOW_CONTROL
        setopt NO_CLOBBER
        setopt NO_CASE_GLOB
        setopt NUMERIC_GLOB_SORT
        setopt EXTENDED_GLOB

        # setup thefuck
        eval $(thefuck --alias)

        # plugins TODO maybe use oh-my-zsh-custom for this

        IGNOREEOF=1
        __BASH_IGNORE_EOF=$IGNOREEOF
        bash-ctrl-d() {
          if [[ -z $__BASH_IGNORE_EOF || $__BASH_IGNORE_EOF == 0 ]]; then
            exit
          else
            __BASH_IGNORE_EOF=$(expr $__BASH_IGNORE_EOF - 1)
          fi
        }

        accept-line-and-reset-ignoreeof() {
          __BASH_IGNORE_EOF=$IGNOREEOF
          zle accept-line
        }

        zle -N bash-ctrl-d
        bindkey "^D" bash-ctrl-d

        zle -N accept-line-and-reset-ignoreeof
        bindkey "^M" accept-line-and-reset-ignoreeof

        source zsh-syntax-highlighting.zsh

        source zsh-history-substring-search.zsh
        bindkey '^[OA' history-substring-search-up
        bindkey '^[OB' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=fg=magenta,bg=default
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=fg=red,bg=default,standout
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
        {
          name = "syntax-highlighting";
          src = pkgs.fetchFromGitHub (fromJSON ''
            {
                "owner": "zsh-users",
                "repo": "zsh-syntax-highlighting",
                "rev": "4ce56a821e9988c1a24fa1b1d62ed57f72893217",
                "sha256": "0p702by1vsgsjxw43mdx00mvbzql1z66f5wyvns3mcyf2k2xhd40"
             }
          '');
        }
        {
          name = "history-substring-search";
          src = pkgs.fetchFromGitHub (fromJSON ''
            {
              "owner": "zsh-users",
              "repo": "zsh-history-substring-search",
              "rev": "47a7d416c652a109f6e8856081abc042b50125f4",
              "sha256": "1mvilqivq0qlsvx2rqn6xkxyf9yf4wj8r85qrxizkf0biyzyy4hl"
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

    services.unclutter = {
      enable = true;
      timeout = 5;
      threshold = 1;
      extraOptions = [
        "-root"
        "-reset"
      ];
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
        "customvimstuff"
        "matplotlib"
        "mpv"
        "nixpkgs"
        "nvim"
        "oh-my-zsh-custom"
        "qterminal.org"
        "youtube-dl"
      ] ++

      # Files in .config
      linkFiles "${configDir}/" [
        "DOTFILES"
      ] ++

      # Directories starting with .
      linkDirs "." [
        "xmonad"
        "mozilla"
        "ipython"
      ] ++

      # Files starting with .
      linkFiles "." [
      ]
    );
  }
