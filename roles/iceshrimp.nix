{ config, pkgs, ... }: {
  services.redis.servers.iceshrimp = {
    enable = true;
    port = 6380;
    bind = "100.93.214.57";
    settings.protected-mode = "no";
  };

  # TODO: move rest of iceshrimp to amy
}
