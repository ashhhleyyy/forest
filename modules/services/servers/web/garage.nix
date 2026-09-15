{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.garage;
in

{
  options.forest.services.garage = {
    enable = lib.mkEnableOption "garage";
    domains = {
      s3 = lib.mkOption {
        description = "Domain name used by s3 clients";
        type = lib.types.str;
      };

      web = lib.mkOption {
        description = "Root domain name used to serve web-accessible buckets.";
        type = lib.types.str;
      };
    };
    secrets = {
      rpc = lib.mkOption {
        type = lib.types.path;
        description = ''
          Age file containing the garage RPC secret.
        '';
      };

      adminToken = lib.mkOption {
        type = lib.types.path;
        description = ''
          Age file containing the garage admin token.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."garage-rpc-secret".file = cfg.secrets.rpc;
    age.secrets."garage-admin-token".file = cfg.secrets.adminToken;

    services.garage = {
      enable = true;
      package = pkgs.garage_2;
      extraEnvironment = {
        GARAGE_ALLOW_WORLD_READABLE_SECRETS = "true";
      };
      settings = {
        replication_factor = 1;
        rpc_bind_addr = "[::]:3901";
        rpc_public_addr = "127.0.0.1:3901";
        rpc_secret_file = "/run/credentials/garage.service/rpc-secret";
        s3_api = {
          s3_region = "garage";
          api_bind_addr = "[::]:3900";
          root_domain = cfg.domains.s3;
        };
        s3_web = {
          bind_addr = "[::]:3902";
          root_domain = cfg.domains.web;
          index = "index.html";
        };
        admin = {
          api_bind_addr = "[::]:3903";
          admin_token_file = "/run/credentials/garage.service/admin-token";
        };
      };
    };

    systemd.services.garage.serviceConfig = {
      LoadCredential = [
        "rpc-secret:${config.age.secrets."garage-rpc-secret".path}"
        "admin-token:${config.age.secrets."garage-admin-token".path}"
      ];
    };

    forest.backups.paths = [ "/var/lib/garage" ];
  };
}
