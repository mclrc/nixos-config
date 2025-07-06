{ config, pkgs, ... }:

{
  # Set up Home Manager
  home.username = "moritz"; # Again, replace 'your-username'
  home.homeDirectory = "/home/your-username";

  # State version for Home Manager
  home.stateVersion = "25.05"; # Match your system.stateVersion or a stable one

  # User-specific packages
  home.packages = with pkgs; [
    # Terminal emulators
    alacritty
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
    fl
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
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Variables/
      # Monitor setup (example)
      # monitor=,preferred,auto,1

      # Some default variables for Hyprland
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORM,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

      # Execute on startup (e.g., set wallpaper, start agents)
      exec-once = ${pkgs.swaybg}/bin/swaybg -i ~/wall.jpg # Set wallpaper (ensure file exists or remove)
      exec-once = systemctl --user import-environment PATH # Import PATH from user environment
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # D-Bus
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 # Polkit agent
      exec-once = ${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh # Keyring

      # Bindings (example)
      bind = SUPER, Q, killactive,
      bind = SUPER, M, exit,
      bind = SUPER, E, exec, ${pkgs.nautilus}/bin/nautilus # File manager
      bind = SUPER, T, exec, ${pkgs.wezterm}/bin/wezterm # Terminal
      bind = SUPER, R, exec, ${pkgs.wofi}/bin/wofi --show drun # App launcher
      bind = SUPER, L, exec, loginctl lock-session # Lock screen
      bind = SUPER_SHIFT, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - # Screenshot

      # Window rules
      windowrulev2 = noborder, class:^()$, title:^(kitty)$, floating:1 # Example rule

      # ... Add more Hyprland config here ...
    '';
  };

  # Set your default terminal emulator (Hyprland will pick this up for $TERMINAL)
  programs.alacritty.enable = true;
  # programs.kitty.enable = true; # If using kitty

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
