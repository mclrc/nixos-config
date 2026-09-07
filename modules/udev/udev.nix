
{
  services.udev.extraRules = ''
    ${builtins.readFile ./udev-rules/40-hilscher-misc.rules}
    ${builtins.readFile ./udev-rules/40-hilscher-netx.rules}
    ${builtins.readFile ./udev-rules/salae-logic.rules}
  '';

}
