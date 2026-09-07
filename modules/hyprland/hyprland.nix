# modules/hyprland/hyprland.nix
#
# Hyprland (home-manager). The actual config is hyprland.lua next to this file;
# see the header there.

{ pkgs, ... }:

{
  # waybar comes from modules/waybar/waybar.nix, rofi from modules/rofi/rofi.nix
  # and alacritty from modules/alacritty.nix -- only the bits nothing else
  # installs live here.
  home.packages = with pkgs; [
    hyprpaper # Wallpaper setter
    hyprcursor
  ];

  wayland.windowManager.hyprland.enable = true;

  # Hyprland 0.56 warns "You are using the .conf config format, support for
  # which will be removed in Hyprland 0.57", so this is now the Lua config
  # (~/.config/hypr/hyprland.lua).
  wayland.windowManager.hyprland.configType = "lua";

  # `settings` is left empty on purpose. home-manager's Lua generator maps each
  # settings attribute to an `hl.<name>(...)` call, so every bind's dispatcher
  # would have to be written as a lib.generators.mkLuaInline string -- escaped
  # Lua inside Nix strings, for sixty-odd binds. Keeping the config as real Lua
  # in hyprland.lua and appending it via extraConfig is both readable and gets
  # LSP completion from the .luarc.json home-manager writes alongside it.
  #
  # extraConfig is appended last, after the systemd/dbus activation hook
  # home-manager generates, so that hook still runs.
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.lua;

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/mclrc/Images/botw.jpg
    wallpaper = ,/home/mclrc/Images/botw.jpg
  '';
}
