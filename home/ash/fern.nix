{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en-gb-large

    krita
    clementine
    spotify
  ];
}
