{ config, pkgs, ... }: {
  services.flatpak.enable = true;

  networking.networkmanager.enable = true;
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

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  programs.adb.enable = true;
}
