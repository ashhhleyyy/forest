{ config, pkgs, ... }: {
  services.redis.servers.iceshrimp = {
    enable = true;
    port = 6380;
    bind = "0.0.0.0";
    settings.protected-mode = "no";
  };

  virtualisation.oci-containers.containers.iceshrimp = {
    image = "git.ashhhleyyy.dev/shorks-gay/iceshrimp:2023.12.11.shorks1";
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

  services.caddy.virtualHosts = {
    "fedi.shorks.gay".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
      log {
        output file /var/log/caddy/fedi.shorks.gay-access.log
      }
      import blockbots
      import errors
    '';

    "media.fedi.shorks.gay".extraConfig = ''
      rewrite * /shorksgay{path}
      reverse_proxy https://pool.jortage.com {
        header_up Host {upstream_hostport}
      }
      log {
        output file /var/log/caddy/media.fedi.shorks.gay-access.log
      }
      import blockbots
    '';
  };

  services.pg-vacuum.databases = [ "shorks-gay" ];
  services.postgresqlBackup.databases = ["shorks-gay"];
}
