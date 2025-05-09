{ config, pkgs, ... }: {
  services.jenkins = {
    enable = true;
    listenAddress = "0.0.0.0";

    packages = [ pkgs.stdenv pkgs.git pkgs.jdk17 pkgs.bash config.programs.ssh.package pkgs.nix ];
  };

  virtualisation.podman.dockerCompat = config.virtualisation.podman.enable;
}
