{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
    libresprite
    kdePackages.korganizer
    kdePackages.kdepim-runtime
    kdePackages.kaddressbook
    #kdePackages.akonadi-notes
    kdePackages.akonadi-mime
    kdePackages.akonadi-search
    kdePackages.akonadi-contacts
    kdePackages.akonadi-calendar
    kdePackages.akonadi-import-wizard
    kdePackages.akonadiconsole
    kdePackages.akonadi
    kdePackages.plasma-browser-integration
    kdePackages.qtwebengine
    rtl-sdr
    signal-desktop
  ];
}
