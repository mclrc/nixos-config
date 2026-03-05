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
      vscode-langservers-extracted # for HTML/CSS/JSON/ESLint LSPs
      vue-language-server # for Vue LSP (volar)
      prettier # for formatting Vue/TS/JS/HTML/CSS
    ];
  };

  xdg.configFile."nvim" = {
    source = ./neovim-config;
    recursive = true;         # Ensure all files in the folder are copied
  };
}
