set positional-arguments

rebuild profile:
  nixos-rebuild switch --flake .#{{profile}}
