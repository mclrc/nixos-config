{ pkgs, ... }:

{
  home.packages = with pkgs; [ neovim ];

  xdg.configFile."nvim" = {
    source = ./neovim-config;
    recursive = true;         # Ensure all files in the folder are copied
  };
}
