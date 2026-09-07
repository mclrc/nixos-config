{ config, pkgs, ... }:

{
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  home.sessionPath = [
    "/home/mclrc/.local/bin"
  ];

  imports = [
    ./modules/hyprland/hyprland.nix
    ./modules/alacritty.nix
    ./modules/waybar/waybar.nix
    ./modules/neovim/neovim.nix
    ./modules/yacoub.nix
    ./modules/rofi/rofi.nix
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    # Deliberately no programs.firefox module; xdg.mimeApps below makes it the
    # default browser.
    firefox
    wl-clipboard
    feh
    nautilus
    nodejs
    libnotify
    git-credential-manager
    fastfetch
    swaylock
    wdisplays
    dconf
    # Electron picks its secret-storage backend from XDG_CURRENT_DESKTOP, which
    # is "Hyprland" here, so it finds neither GNOME nor KDE, falls back to
    # plaintext and warns that no OS keyring could be found. gnome-keyring does
    # serve org.freedesktop.secrets (services.gnome.gnome-keyring in
    # configuration.nix) — just name the backend. commandLineArgs appends the
    # flag inside the launcher script, so it applies to cursor.desktop too.
    (code-cursor.override { commandLineArgs = "--password-store=gnome-libsecret"; })
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
    poppler-utils
    tokei
    pdfpc

    # Referenced by the hyprland binds / waybar; see modules/hyprland/hyprland.nix.
    brightnessctl
    playerctl
    networkmanagerapplet

    wineWow64Packages.stable
    winetricks
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

    settings = {
      user = {
        name = "mclrc-yacoub";
        email = "moritz.clerc@yacoub.de";
      };
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
      nixai = {
        body = ''
          # Jump to this NixOS config via zoxide and start Claude there.
          # Optional argument is used as the initial prompt:
          #   nixai "add ripgrep-all to my user packages"
          # Leading-dash arguments are passed straight through: nixai -c
          set -l dir (zoxide query nixos-config 2>/dev/null)
          if test -z "$dir" -o ! -d "$dir"
            set dir "$HOME/nixos-config"
          end
          if not test -d "$dir"
            echo "nixai: no nixos-config directory found"
            return 1
          end
          cd $dir
          if test (count $argv) -eq 0
            claude
          else if string match -qr '^-' -- $argv[1]
            claude $argv
          else
            claude "$argv"
          end
        '';
      };
    };
  };

  programs.ssh = {
    enable = true;

    # Opt out of home-manager's implicit `Host *` block; the only value we
    # actually want is set below. Home-manager emits "*" last, so the specific
    # host blocks still win.
    enableDefaultConfig = false;

    settings = {
      "github-personal" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/github_personal";
        IdentitiesOnly = true;
      };
      "cg-gitlab" = {
        HostName = "gitlab.cg.tu-berlin.de";
        IdentityFile = "~/.ssh/github_personal";
        IdentitiesOnly = true;
      };
      "*" = {
        AddKeysToAgent = "yes";
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
    enable = true;
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
    # GTK4 apps use libadwaita rather than theme directories, so no gtk4 theme.
    gtk4.theme = null;
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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    # Carried over from the hand-written ~/.config/mimeapps.list this replaces.
    "x-scheme-handler/sgnl" = "signal.desktop";
    "x-scheme-handler/signalcaptcha" = "signal.desktop";
    "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
  };
}

