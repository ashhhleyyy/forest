{ config, lib, ... }:

let
  cfg = config.forest.services.immich;
in

{
  options.forest.services.immich = {
    enable = lib.mkEnableOption "immich";
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      host = "::";
      machine-learning.environment = {
        IMMICH_PORT = lib.mkForce "3007";
      };
    };

    services.postgresqlBackup.databases = [ "immich" ];
    forest.backups.paths = [ "/var/lib/immich" ];

    nixpkgs.config.permittedInsecurePackages = [
      "immich-2.7.5" # TODO: remove when upgrading to nixos 26.11
    ];
  };
}
