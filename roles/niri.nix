{ lib, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "gb";
    };
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
    };
  };
  programs.niri.enable = true;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  hardware.graphics.enable = true;

  programs.nm-applet.enable = true;
}
