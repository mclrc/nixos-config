{ config, pkgs, ... }:

{
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  home.sessionPath = [
    # "/home/mclrc/arm/bin"
    "/home/mclrc/.local/bin"
  ];

  imports = [
    ./modules/hyprland.nix
    ./modules/alacritty.nix
    ./modules/waybar/waybar.nix
    ./modules/neovim/neovim.nix
    ./modules/yacoub.nix
    ./modules/rofi/rofi.nix
    ./modules/firefox.nix
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    kitty
    wl-clipboard
    feh
    nautilus
    gh
    bibata-cursors
    nodejs
    libnotify
    lazygit
    git-credential-manager
    zoxide
    fastfetch
    swaylock
    wdisplays
    dconf
    code-cursor
    xdg-utils
    vscode
    flameshot
    fd
    sublime-merge
    hyprshot
    pipenv
    bun
    obsidian
    bear
    tor-browser
    signal-desktop
    pavucontrol
    wireshark
    qmk
    vial
    chromium
    discord
    tcpdump
    spotify
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [ "green" "bold" ];
          inactiveBorderColor = [ "white" ];
          optionsTextColor = [ "blue" ];
          selectedLineBgColor = [ "blue" ];
          selectedRangeBgColor = [ "blue" ];
          cherryPickedCommitBgColor = [ "cyan" ];
          cherryPickedCommitFgColor = [ "blue" ];
          unstagedChangesColor = [ "red" ];
          stagedChangesColor = [ "green" ];
          trackedFilesColor = [ "green" ];
          untrackedFilesColor = [ "red" ];
          diffDeletedColor = [ "red" ];
          diffAddedColor = [ "green" ];
          diffContextColor = [ "yellow" ];
          commitTextColor = [ "yellow" ];
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "mclrc-yacoub";
    userEmail = "moritz.clerc@yacoub.de";

    extraConfig = {
      credential = {
        helper = "gnome-keyring";
      };
      core = {
        editor = "vim";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
        enable = true;
      };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      gemini = "npx @google/gemini-cli";
      nr = "npm run";
      nrl = "npm run lint";
      nrd = "npm run dev";
      j = "just";
      gs = "git status";
      gl = "git log";
      netnode-serial = "picocom --baud 115200 --imap lfcrlf --echo --flow h";
    };
    functions = {
      ide = {
        body = ''
          set dir (zoxide query $argv[1])
          if test -z "$dir"
            echo "ide: no match for '$argv[1]'"
            return 1
          end
          alacritty --working-directory $dir -e agent &; disown
          alacritty --working-directory $dir &; disown
          cd $dir
          nvim .
        '';
      };
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github-personal" = {
        hostname = "github.com";
        identityFile = "~/.ssh/github_personal";
        identitiesOnly = true;
      };
    };
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Iosevka Term 14";
        format = ''<b>%s</b>
%b'';
        word_wrap = "yes";
        frame_color = "#8aadf4";
        separator_color = "frame";
        highlight = "#8aadf4";
        origin = "top-right";
        offset = "10x10";
      };
      urgency_low = {
        background = "#24273a";
        foreground = "#cad3f5";
        timeout = 20;
      };
      urgency_normal = {
        background = "#24273a";
        foreground = "#cad3f5";
        timeout = 10;
      };
      urgency_critical = {
        background = "#24273a";
        foreground = "#cad3f5";
        frame_color = "#f5a97f";
        timeout = 0;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}

