{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
