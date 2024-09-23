{ config, pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
  networking.firewall.trustedInterfaces = ["podman0"];
}
