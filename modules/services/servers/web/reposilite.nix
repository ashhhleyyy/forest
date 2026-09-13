{ config, lib, ... }:

let
  cfg = config.forest.services.reposilite;
in

{
  options.forest.services.reposilite = {
    enable = lib.mkEnableOption "reposilite";
  };

  config = lib.mkIf cfg.enable {
    services.reposilite = {
      enable = true;
      settings = {
        port = 3005;
      };
      database = {
        type = "sqlite";
        path = "reposilite.db";
      };
    };

    forest.backups.paths = [ "/var/lib/reposilite" ];
  };
}
