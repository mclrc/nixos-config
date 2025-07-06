{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = { normal = { family = "Inconsolata"; }; size = 9; };
    };
  };
}
