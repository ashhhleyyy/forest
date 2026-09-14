{ config, lib, ... }:

let
  cfg = config.forest.services.gotosocial;
in

{
  options.forest.services.gotosocial = {
    enable = lib.mkEnableOption "gotosocial";
    host = lib.mkOption {
      description = "Host name for the GoToSocial instance";
      type = lib.types.str;
    };
    caddy.enable = lib.mkEnableOption "gotosocial caddy vhost";
  };

  config = lib.mkIf cfg.enable {
    # age.secrets.gts-sandbox.file = ../secrets/gts-sandbox.age;

    services.gotosocial = {
      enable = true;
      setupPostgresqlDB = true;
      settings = {
        host = cfg.host;
        port = 3001;
        trusted-proxies = ["127.0.0.1/32"];
        bind-address = "0.0.0.0";
        accounts-registration-open = true;
        accounts-reason-required = true;
      };
      #environmentFile = config.age.secrets.gts-sandbox.path;
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = lib.mkIf cfg.caddy.enable ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:3001
    '';

    services.postgresqlBackup.databases = ["gotosocial"];
    forest.backups.paths = [ "/var/lib/gotosocial" ];
  };
}
