{ pkgs, ... }: {
  services.munin-node = {
    enable = true;
  };
}
