{ pkgs, config, ... }: {
  services.node-red = {
    enable = true;
    withNpmAndGcc = true;
  };
}
