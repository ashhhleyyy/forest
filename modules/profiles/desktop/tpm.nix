{ config, lib, ... }:

let
  cfg = config.forest.profiles.desktop.tpm;
in

{
  options.forest.profiles.desktop.tpm = {
    enable = lib.mkEnableOption "desktop tpm";
  };

  config = lib.mkIf cfg.enable {
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;
    security.tpm2.tctiEnvironment.enable = true;
    users.users.ash.extraGroups = [ "tss" ];
    users.groups.uhid = {
      members = [ "ash" ];
    };
    services.udev.extraRules = ''
    KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="uhid", MODE="0660"
    '';
  };
}
