{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en-gb-large
    fluffychat

    krita
    clementine
    spotify
  ];
}
