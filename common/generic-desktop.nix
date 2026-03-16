{ config, pkgs, ... }: {
  services.flatpak.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];
  services.smartd.enable = true;

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openconnect ];
  };
  services.resolved.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  programs.kdeconnect.enable = true;

  users.users.ash.extraGroups = [ "networkmanager" "adbusers" ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin.override { variant = "latte"; accent = "mauve"; })];
    theme = "catppuccin-latte";
  };
  boot.initrd.systemd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    doas.u2fAuth = true;
  };

  environment.systemPackages = with pkgs; [
    android-tools
    smartmontools
    pciutils
    usbutils
  ];

  # TODO: depends on insecure qtwebengine
  #services.globalprotect.enable = true;

  fonts.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
    maple-mono.NF
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
