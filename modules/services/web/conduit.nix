{ config, lib, ... }:

let
  cfg = config.fern.services.conduit;
in

{
  options.fern.services.conduit = {
    enable = lib.mkEnableOption "conduit";
    serverName = lib.mkOption {
      type = lib.types.str;
    };
    frontends.enable = lib.mkEnableOption "matrix frontends";
  };

  config = lib.mkIf cfg.enable {
    services.matrix-conduit = {
      enable = true;
      settings = {
        global = {
          server_name = cfg.serverName;
          database_backend = "rocksdb";
          allow_check_for_updates = true;
          address = "::";
        };
      };
    };

    services.caddy.virtualHosts = {
      "matrix.${cfg.serverName}".extraConfig = ''
        reverse_proxy 127.0.0.1:6167
      '';

      "schildi.${cfg.serverName}".extraConfig = lib.mkIf cfg.frontends.enable ''
        root * /var/www/schildichat-web
        file_server
      '';

      "cinny.${cfg.serverName}".extraConfig = lib.mkIf cfg.frontends.enable ''
        root * /var/www/cinny
        file_server
      '';
    };

    forest.backups.paths = [ "/var/lib/private/matrix-conduit" ];
  };
}
