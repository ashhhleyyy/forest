{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    wineWowPackages.stable
    # celeste mod manager
    olympus
  ];
}
