{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.binary-ninja-personal
  ];
}
