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
  ];

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
}
