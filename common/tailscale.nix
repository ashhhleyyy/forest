{ ... }: {
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = ["tailsacle0"];
}
