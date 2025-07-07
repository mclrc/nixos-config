{ pkgs, ... }:

{
    home.packages = with pkgs; [
       docker
       gnumake
       cmake
       gcc-arm-embedded
       gdb
    ];
}
