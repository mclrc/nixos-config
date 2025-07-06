{ config, pkgs, ... }:

{
  # Set up Home Manager
  # home.username = "moritz"; # Again, replace 'your-username'
  # home.homeDirectory = "/home/moritz";

  # State version for Home Manager
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  imports = [ ./modules/hyprland.nix ./modules/alacritty.nix ];

  # User-specific packages
  home.packages = with pkgs; [
    # Terminal emulators
    alacritty
    kitty
    # Wayland native applications
    waybar # Status bar
    wofi # Application launcher (or rofi-wayland, fuzzel, etc.)
    swaybg # Wallpaper setter
    wl-clipboard # Wayland clipboard utilities
    # General utilities
    feh # Image viewer (works on XWayland)
    # Web browser
    # firefox
    # File manager
    nautilus # or thunar, pcmanfm
  ];

  # Hyprland configuration via Home Manager
  # This is usually where you put your ~/.config/hypr/hyprland.conf content
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true; # For X11 apps in Hyprland
    systemd.enable = true; # Integrate with systemd (important!)

    # Main Hyprland configuration (equivalent to hyprland.conf)
    # Define your binds, layouts, rules, etc. here
    # Start with a basic config and expand
  };

  # Set your default terminal emulator (Hyprland will pick this up for $TERMINAL)
  programs.alacritty.enable = true;
  programs.kitty.enable = true; # If using kitty

  # Git config
  programs.git.enable = true;
  programs.git.userName = "mclrc";
  programs.git.userEmail = "moritzamando@proton.me";

  # Enable zsh if you want to use it
  # programs.zsh.enable = true;
  # programs.zsh.enableCompletion = true;
  # programs.zsh.ohMyZsh.enable = true;
  # programs.zsh.ohMyZsh.plugins = [ "git" "history" ];
  # programs.zsh.ohMyZsh.customPlugins = [
  #   {
  #     name = "zsh-syntax-highlighting";
  #     src = "${pkgs.zsh-syntax-highlighting}/share/zsh/site-functions";
  #   }
  # ];

  # Other dotfiles via Home Manager
  # programs.neovim.enable = true;
  # programs.neovim.extraConfig = ''
  #   set number
  #   set tabstop=4
  # '';
}
