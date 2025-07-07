{
  description = "A flake for my NixOS Hyprland setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use unstable for latest Hyprland

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same nixpkgs as us

    hyprland.url = "github:hyprland-community/hyprland-nix";
    hyprland.inputs.nixpkgs.follows = "nixpkgs"; # Hyprland should use our nixpkgs
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixusb = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.moritz = import ./home.nix;
          }
        ];
      };
    };
}
