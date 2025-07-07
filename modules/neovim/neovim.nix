{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      pynvim
      flake8
      pip
    ]);
  };

  xdg.configFile."nvim" = {
    source = ./neovim-config;
    recursive = true;         # Ensure all files in the folder are copied
  };
}
