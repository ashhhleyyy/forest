{ config, pkgs, ... }: {
  services.redis.servers.iceshrimp = {
    enable = true;
    port = 6380;
    bind = "0.0.0.0";
    settings.protected-mode = "no";
  };

  # TODO: move rest of iceshrimp to amy
}
