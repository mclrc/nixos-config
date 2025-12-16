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
      # Configure virtiofsd path
      qemuVerbatimConfig = ''
        virtiofsd_path = "/run/current-system/sw/bin/virtiofsd"
      '';
    };
    # Enable SPICE for USB redirection.
    spiceUSBRedirection.enable = true;
  };

  # Enable the virt-manager GUI.
  programs.virt-manager.enable = true;

  # Enable Samba for VM file sharing (local only)
  services.samba = {
    enable = true;
    openFirewall = false;  # Don't open globally
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS Samba";
        "security" = "user";
        "interfaces" = "lo virbr0";  # Only listen on localhost and libvirt network
        "bind interfaces only" = "yes";
      };
      "shared" = {
        "path" = "/home/mclrc/shared";
        "browseable" = "yes";
        "writable" = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "hosts allow" = "127.0.0.1 192.168.122.0/24";  # Only allow from libvirt network
      };
    };
  };

  # Allow Samba only from libvirt network
  networking.firewall.interfaces."virbr0".allowedTCPPorts = [ 445 139 ];
  networking.firewall.interfaces."virbr0".allowedUDPPorts = [ 137 138 ];

  # Install necessary packages.
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_full
    virtio-win
    spice
    spice-gtk
    spice-protocol
    win-virtio
    swtpm
    virtiofsd
  ];
}
