{ config, pkgs, ... }: {
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
