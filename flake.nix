# ~/nixos-config/flake.nix
{
  description = "A flake for my NixOS Hyprland setup";

  # Define inputs for your flake
  inputs = {
    # Nixpkgs: The main Nix packages collection
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use unstable for latest Hyprland

    # Home Manager: For managing user-specific configurations (dotfiles, user programs)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same nixpkgs as us

    # Hyprland: The compositor itself
    hyprland.url = "github:hyprland-community/hyprland-nix";
    hyprland.inputs.nixpkgs.follows = "nixpkgs"; # Hyprland should use our nixpkgs

    # Optional: For Nix-specific VSCode config, etc.
    # nix-colors.url = "github:GabeIglesias/nix-colors"; # If you want to manage themes

    # Other inputs you might add later:
    # - your dotfiles repo if separate
    # - a specific neovim config flake
    # - etc.
  };

  # Define outputs of your flake
  outputs = { self, nixpkgs, home-manager, hyprland, ... }:
    let
      # Define the system architecture
      system = "x86_64-linux";

      # Make nixpkgs accessible with the chosen system
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Allow proprietary software (e.g., Google Chrome, some drivers)
      };
    in {
      # Define your NixOS configuration(s) here
      nixosConfigurations.nixusb = nixpkgs.lib.nixosSystem {
        inherit system pkgs; # Pass the system architecture and our configured nixpkgs

        # Modules are where you define your system settings
        modules = [
          # Import Home Manager's NixOS module
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.moritz = import ./home.nix; # Link to your home-manager config
            # Replace 'your-username' with your actual username on the system
          }

          # If you have specific hardware configurations, put them here
          # For example, ./hardware-configuration.nix (usually copied from /etc/nixos)
          # ./disko.nix # If managing disk layout with disko
        ];
      };
    };
}
