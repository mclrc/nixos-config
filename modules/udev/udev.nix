
{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="*", ATTR{idProduct}=="*", GROUP="users"
    ${builtins.readFile ./udev-rules/40-hilscher-misc.rules}
    ${builtins.readFile ./udev-rules/40-hilscher-netx.rules}
  '';

}
