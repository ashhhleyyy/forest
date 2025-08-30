{ config
, pkgs
, ...
}:
{
  services.jenkins = {
    enable = true;
    listenAddress = "0.0.0.0";
    extraGroups = ["podman"];

    packages = [ pkgs.stdenv pkgs.git pkgs.jdk17 pkgs.bash config.programs.ssh.package pkgs.nix pkgs.docker-client ];
  };

  #virtualisation.podman.dockerCompat = config.virtualisation.podman.enable;
  forest.backups.paths = [ "/var/lib/jenkins" ];
}
