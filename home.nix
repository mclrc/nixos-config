{ config, pkgs, ... }:

{
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  imports = [
    ./modules/hyprland.nix
    ./modules/alacritty.nix
    ./modules/waybar/waybar.nix
    ./modules/neovim/neovim.nix
    ./modules/yacoub.nix
  ];

  home.packages = with pkgs; [
    kitty
    wl-clipboard
    feh
    nautilus
    firefox
    gh
    bibata-cursors
    nodejs
    libnotify
    lazygit
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
    userName = "mclrc";
    userEmail = "moritzamando@proton.me";

    extraConfig = {
      core = {
        editor = "vim";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      gemini = "npx @google/gemini-cli";
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
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
}

