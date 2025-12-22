{ config, pkgs, ... }: {
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
}
