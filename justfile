set positional-arguments

update:
  nix flake update
rebuild profile:
  nixos-rebuild switch --flake .#{{profile}}
