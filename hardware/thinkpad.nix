{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6ac6a645-5b26-425f-9307-8cebb855a9cc";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-e77ee270-bf49-4dc2-8646-4341edd9c23a".device = "/dev/disk/by-uuid/e77ee270-bf49-4dc2-8646-4341edd9c23a";
  boot.initrd.luks.devices."luks-50e14a82-8f16-4905-812c-3a1e4d697eaa".device = "/dev/disk/by-uuid/50e14a82-8f16-4905-812c-3a1e4d697eaa";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5658-629C";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/6f00c798-ac2d-4a37-92d0-dd0ffb22ca76"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.enable = true;

  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
  };
}
