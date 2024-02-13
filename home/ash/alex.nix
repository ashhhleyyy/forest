{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
    libresprite
    plover.dev
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
