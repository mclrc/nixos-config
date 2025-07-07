{ config, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        extraConfig = ''
          [alt]
          x = C-x
          c = C-c
          v = C-v

          a = C-a
          f = C-f
          r = C-r
          z = C-z

          w = C-w
          s = C-s

          Return = C-Return
          t = C-t

          [main]
          capslock = layer(vim)

          [vim]
          h = left
          k = up
          j = down
          l = right
          d = control
          f = shift
        '';
      };
    };
  };
}
