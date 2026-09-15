{
  config,
  lib,
  pkgs,
  ...
}:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.net.isnt-a.top".directory;
  cfg = config.forest.services.kanidm;
in

{
  options.forest.services.kanidm = {
    server = {
      enable = lib.mkEnableOption "kanidm-server";
      origin = lib.mkOption {
        description = "Full base URL of this server instance";
        type = lib.types.str;
      };
    };
    client = {
      enable = lib.mkEnableOption "kanidm-client";
      server = lib.mkOption {
        description = "URL of the kanidm server to use with this client";
        type = lib.types.str;
        default = "https://sso.ashhhleyyy.dev";
      };
    };
  };

  config = {
    services.kanidm = lib.mkIf (cfg.server.enable || cfg.client.enable) {
      package = pkgs.kanidm_1_11;

      server = lib.mkIf cfg.server.enable {
        enable = true;
        settings = {
          version = "2";
          bindaddress = "[::]:3006";
          ldapbindaddress = "[::]:3636";
          tls_chain = "${tls-dir}/fullchain.pem";
          tls_key = "${tls-dir}/key.pem";
          log_level = "info";
          domain = "sso.ashhhleyyy.dev";
          origin = cfg.server.origin;
          role = "WriteReplica";
          http_client_address_info."x-forward-for" = [ ];
          online_backup = {
            path = "/var/lib/kanidm/backups/";
            schedule = "0 3 * * *";
            versions = 7;
          };
        };
      };

      client = lib.mkIf cfg.client.enable {
        enable = true;
        settings = {
          uri = cfg.client.server;
        };
      };
    };

    users.users.kanidm = lib.mkIf cfg.server.enable {
      extraGroups = [ "acme" ];
    };

    forest.backups.paths = lib.mkIf cfg.server.enable [ "/var/lib/kanidm/backups/" ];
  };
}
