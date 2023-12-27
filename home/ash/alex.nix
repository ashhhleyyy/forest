{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
    libresprite
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
