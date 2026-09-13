{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.docker-registry;
in

{
  options.forest.services.docker-registry = {
    enable = lib.mkEnableOption "docker-registry";
  };

  config = lib.mkIf cfg.enable {
    services.dockerRegistry = {
      enable = true;
      listenAddress = "[::]";
    };

    systemd.services.docker-registry.environment.OTEL_TRACES_EXPORTER = "none";

    forest.backups.paths = [ "/var/lib/docker-registry" ];
  };
}
