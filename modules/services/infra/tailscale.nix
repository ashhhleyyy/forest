{ config, lib, ... }: {
  options.forest.services.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };
  config = lib.mkIf config.forest.services.tailscale.enable {
    services.tailscale.enable = true;
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
