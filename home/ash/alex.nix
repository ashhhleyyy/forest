{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
    libresprite
    plover.dev
    libsForQt5.korganizer
    libsForQt5.kdepim-runtime
    libsForQt5.kaddressbook
    libsForQt5.akonadi-notes
    libsForQt5.akonadi-mime
    libsForQt5.akonadi-search
    libsForQt5.akonadi-contacts
    libsForQt5.akonadi-calendar
    libsForQt5.akonadi-import-wizard
    libsForQt5.akonadiconsole
    libsForQt5.akonadi
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
