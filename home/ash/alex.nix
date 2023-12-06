{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
  ];
}
