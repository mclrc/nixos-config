# Shared by all three hosts. Per-machine settings live in hardware/<host>.nix.
# System-level options only (services.*, environment.*, boot.*, users.*);
# anything user-facing belongs in home.nix.

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    ./modules/keyd.nix
    ./modules/udev/udev.nix
    ./modules/virtualisation.nix
    ./modules/bsprak.nix
  ];

  # Root-and-boot tooling only. User-facing packages go in home.nix.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    killall
    gcc
    unzip
    rustup
    go
    ripgrep
    gnome-keyring
    keyd

    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc

    clang
    clang-tools
    glibc

    just
    usbutils
    htop

    lsof

    nix-search-cli
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.hyprland.default = [ "hyprland" "gtk" ];
  };

  hardware.graphics.enable32Bit = true;

  hardware.keyboard.qmk.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName is set per-host in flake.nix so that it matches the
  # nixosConfigurations name (thinkpad / desktop / nixusb).
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.groups.plugdev = {};

  users.users.mclrc = {
    isNormalUser = true;
    description = "Moritz";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "docker" "plugdev" "dialout" "libvirtd" "audio" "wireshark" ];
  };

  services.envfs.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.inconsolata
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Installs wireshark-cli plus the dumpcap capability wrapper for the
  # `wireshark` group; the GUI itself is a home.nix package.
  programs.wireshark.enable = true;

  # programs.nix-ld is enabled with its library set in modules/bsprak.nix.

  virtualisation.docker.enable = true;

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Do not change it.
  system.stateVersion = "25.05";
}
