{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    wineWow64Packages.waylandFull
    # celeste mod manager
    olympus
    melonds
    osu-lazer-bin
    alsa-oss
    prismlauncher
    gnome-sudoku
  ];
}
