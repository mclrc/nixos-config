{ config, pkgs, ... }:

{
  # Enable KVM by loading the appropriate kernel module.
  # Use "kvm-amd" if you have an AMD processor.
  boot.kernelModules = [ "kvm-intel" ];

  # Enable the libvirtd service to manage virtual machines.
  virtualisation = {
    libvirtd = {
      enable = true;
      # Enable OVMF for UEFI support in VMs.
      qemu.ovmf.enable = true;
      # Enable swtpm for TPM 2.0 support in VMs.
      qemu.swtpm.enable = true;
    };
    # Enable SPICE for USB redirection.
    spiceUSBRedirection.enable = true;
  };

  # Enable the virt-manager GUI.
  programs.virt-manager.enable = true;

  # Install necessary packages.
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_full
  ];
}
