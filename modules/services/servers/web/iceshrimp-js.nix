{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.iceshrimp-js;
in

{
  options.forest.services.iceshrimp-js = {
    enable = lib.mkEnableOption "iceshrimp.js";
    caddy.enable = lib.mkEnableOption "iceshrimp.js caddy vhosts";
  };

  config = lib.mkIf cfg.enable {
    services.redis.servers.iceshrimp = {
      enable = true;
      port = 6380;
      bind = "0.0.0.0";
      settings.protected-mode = "no";
    };

    virtualisation.oci-containers.containers.iceshrimp = {
      image = "jessica:5000/withdrawal:2026.5.1.shorks4";
      autoStart = false;
      environment = {
        NODE_ENV = "production";
      };
      ports = [
        "3000:3000"
      ];
      volumes = [
        "/home/ash/shorks-gay/files:/iceshrimp/files"
        "/home/ash/shorks-gay/.config:/iceshrimp/.config:ro"
      ];
    };

    services.caddy.virtualHosts = lib.mkIf cfg.caddy.enable {
      "fedi.shorks.gay".extraConfig = ''
        reverse_proxy 127.0.0.1:3000
        import blockbots
        import errors
      '';

      "media.fedi.shorks.gay".extraConfig = ''
        rewrite * /shorksgay{path}
        reverse_proxy https://pool.jortage.com {
          header_up Host {upstream_hostport}
        }
        import blockbots
      '';
    };

    forest.services.pg-vacuum.databases = [ "shorks-gay" ];
    services.postgresqlBackup.databases = ["shorks-gay"];
    forest.backups.paths = ["/home/ash/shorks-gay/"];
  };
}
