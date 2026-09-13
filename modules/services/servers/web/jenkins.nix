{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.jenkins;
in

{
  options.forest.services.jenkins = {
    enable = lib.mkEnableOption "jenkins";
  };

  config = lib.mkIf cfg.enable {
    services.jenkins = {
      enable = true;
      listenAddress = "0.0.0.0";
      extraGroups = ["podman"];

      packages = with pkgs; [
        stdenv
        git
        jdk17
        bash
        config.programs.ssh.package
        nix
        docker-client
        forgejo-cli
        awscli2
      ];
    };

    forest.backups.paths = [ "/var/lib/jenkins" ];
  };
}
