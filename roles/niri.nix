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
  hardware.graphics.enable = true;
}
