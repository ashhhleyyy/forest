{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    wineWow64Packages.waylandFull
    # celeste mod manager
    olympus
    melonDS
    osu-lazer
    alsa-oss
    prismlauncher
    gnome-sudoku
  ];
}
