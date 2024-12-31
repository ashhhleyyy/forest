{ pkgs, ... }: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "4000";
    };
  };

  services.caddy.virtualHosts."monitoring.service.ashhhleyyy.dev".extraConfig = ''
    log {
      output file /var/log/caddy/monitoring.service.ashhhleyyy.dev-access.log
    }

    reverse_proxy localhost:4000
  '';
}
