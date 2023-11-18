{ config, pkgs, ... }: {
  services.flatpak.enable = true;

  services.resolved.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.utf8";

  boot.plymouth = {
    enable = true;
  };
  boot.initrd.systemd.enable = true;
}
