{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.profiles.desktop.niri;
in

{
  options.forest.profiles.desktop.niri = {
    enable = lib.mkEnableOption "niri desktop profile";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    programs.niri.enable = true;
    services.gnome.gnome-keyring.enable = lib.mkForce false;
    security.pam.services.plasmalogin.kwallet = {
      enable = true;
      forceRun = true;
    };
    xdg.portal = {
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      config.niri = {
        "org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
      };
    };
    qt = {
      enable = true;
      style = "breeze";
    };
  };
}
