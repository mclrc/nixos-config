{ pkgs, ... }:

{
  home.packages = with pkgs; [ neovim ];

  xdg.configFile."neovim" = {
    source = ./neovim-config;
    recursive = true;         # Ensure all files in the folder are copied
  };
}
