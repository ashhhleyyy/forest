{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];
}
