{ config, nixpkgs, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.gateway
    obsidian
    libresprite
    plover.dev
    kdePackages.korganizer
    kdePackages.kdepim-runtime
    kdePackages.kaddressbook
    kdePackages.akonadi-notes
    kdePackages.akonadi-mime
    kdePackages.akonadi-search
    kdePackages.akonadi-contacts
    kdePackages.akonadi-calendar
    kdePackages.akonadi-import-wizard
    kdePackages.akonadiconsole
    kdePackages.akonadi
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
