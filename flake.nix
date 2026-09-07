{
  description = "A flake for my NixOS Hyprland setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use unstable for latest Hyprland

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same nixpkgs as us
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        config.permittedInsecurePackages = [
          "segger-jlink-qt4-952"
        ];
        config.segger-jlink.acceptLicense = true;
      };

      # One host = its hardware file + the shared config + home-manager.
      # `name` is both the nixosConfigurations attribute and networking.hostName;
      # the justfile relies on those two matching. `hardware` names the file in
      # hardware/ and defaults to `name` -- nixusb is the one host where they differ.
      mkHost = { name, hardware ? name }: nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          ./hardware/${hardware}.nix
          ./configuration.nix
          home-manager.nixosModules.default
          {
            networking.hostName = name;

            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.mclrc = import ./home.nix;
          }
        ];
      };
    in {
      nixosConfigurations = {
        thinkpad = mkHost { name = "thinkpad"; };
        desktop = mkHost { name = "desktop"; };
        nixusb = mkHost { name = "nixusb"; hardware = "usb"; };
      };
    };
}
