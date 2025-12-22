{ config, pkgs, ... }: {
  services.dockerRegistry = {
    enable = true;
    listenAddress = "[::]";
  };

  systemd.services.docker-registry.environment.OTEL_TRACES_EXPORTER = "none";

  forest.backups.paths = [ "/var/lib/docker-registry" ];
}
