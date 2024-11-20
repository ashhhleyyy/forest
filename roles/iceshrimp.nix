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
}
