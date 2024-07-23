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
  ];
}
