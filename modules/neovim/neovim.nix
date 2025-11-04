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
    extraPackages = with pkgs; [
      clang-tools # for clang-format
      typescript-language-server # for TypeScript LSP
      vscode-langservers-extracted # for ESLint LSP
    ];
  };

  xdg.configFile."nvim" = {
    source = ./neovim-config;
    recursive = true;         # Ensure all files in the folder are copied
  };
}
