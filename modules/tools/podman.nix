{ config, pkgs, lib, ... }:

let
  cfg = config.forest.tools.podman;
in

{
  options.forest.tools.podman = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
    };
    virtualisation.containers.registries.insecure = [
      "jessica:5000"
    ];
    virtualisation.oci-containers.backend = "podman";
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
    networking.firewall.trustedInterfaces = ["podman0"];
  };
}
