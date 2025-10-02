{ pkgs, ... }:

{
  home.file.".config/hyprpaper/hyprpaper.conf".text = ''
    preload = /home/mclrc/Images/botw.jpg
    wallpaper = ,/home/mclrc/Images/botw.jpg
  '';
}
