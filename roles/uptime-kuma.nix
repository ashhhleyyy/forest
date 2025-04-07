{ pkgs, ... }: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = "4000";
    };
  };

  services.caddy.virtualHosts."monitoring.service.ashhhleyyy.dev".extraConfig = ''
    reverse_proxy localhost:4000
  '';
}
