# /etc/nixos/modules/waybar.nix
{ pkgs, ... }:

{
  # Ensure Waybar is installed
  home.packages = with pkgs; [ waybar ];

  # Copy the Waybar configuration folder to ~/.config/waybar
  xdg.configFile."waybar" = {
    source = ./waybar-config; # Path to your Waybar config folder
    recursive = true;         # Ensure all files in the folder are copied
  };
}
