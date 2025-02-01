{ pkgs, ... }: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "4000";
    };
  };

  services.caddy.virtualHosts."monitoring.service.ashhhleyyy.dev".extraConfig = ''
    reverse_proxy localhost:4000
  '';
}
