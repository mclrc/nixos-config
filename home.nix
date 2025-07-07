{ config, pkgs, ... }:

{
  # Set up Home Manager
  # home.username = "moritz"; # Again, replace 'your-username'
  # home.homeDirectory = "/home/moritz";

  # State version for Home Manager
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  imports = [ ./modules/hyprland.nix ./modules/alacritty.nix ./modules/waybar/waybar.nix ./modules/neovim/neovim.nix ];

  # User-specific packages
  home.packages = with pkgs; [
    # Terminal emulators
    kitty
    # Wayland native applications
    wl-clipboard # Wayland clipboard utilities
    # General utilities
    feh # Image viewer (works on XWayland)
    # Web browser
    # firefox
    # File manager
    nautilus # or thunar, pcmanfm
    firefox
    asdf-vm
  ];

  # Git config
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
  };

  # Other dotfiles via Home Manager
  # programs.neovim.enable = true;
  # programs.neovim.extraConfig = ''
  #   set number
  #   set tabstop=4
  # '';
}
