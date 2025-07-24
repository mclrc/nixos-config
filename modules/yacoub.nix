{ pkgs, ... }:

{
    home.packages = with pkgs; [
       docker
       docker-compose
       gnumake
       cmake
       gcc-arm-embedded
       pulseview
       picocom
       openocd
       stlink
    ];
}
