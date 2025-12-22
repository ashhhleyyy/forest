{ config, pkgs, ... }: {
  services.dockerRegistry = {
    enable = true;
    listenAddress = "[::]";
  };

  forest.backups.paths = [ "/var/lib/docker-registry" ];
}
