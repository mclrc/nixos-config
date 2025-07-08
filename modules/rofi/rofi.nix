{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      "drun-display-format" = "{name}";
      font = "JetBrainsMono Nerd Font 12";
      theme = ./theme.rasi;
    };
  };
}
