{ config, pkgs, ... }: {
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
}
