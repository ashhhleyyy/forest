{ config, pkgs, ... }: {
  services.flatpak.enable = true;

  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
  };
  users.users.ash.extraGroups = [ "networkmanager" ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.utf8";

  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin.override { variant = "mocha"; accent = "mauve"; })];
    theme = "catppuccin-mocha";
  };
  boot.initrd.systemd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  programs.adb.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    maple-mono-NF
    atkinson-hyperlegible
    liberation_ttf
    ocr-a
    (pkgs.stdenv.mkDerivation {
      pname = "libre-barcode";
      version = "1.008";
      src = pkgs.fetchzip {
        url = "https://github.com/graphicore/librebarcode/releases/download/v1.008/LibreBarcode_v1.008.zip";
        hash = "sha256-2Tqpjb+wBrfawgdRdrL+rfJeYLsnwMhfDkwIBt2HWkE=";
      };
      installPhase = ''
      install -D -m 0644 $src/LibreBarcode39-Regular.ttf $out/share/fonts/truetype/LibreBarcode39-Regular.ttf
      '';
    })
  ];
}
