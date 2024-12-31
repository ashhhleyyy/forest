{ pkgs, ... }: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = 4000;
    };
  };

  services.caddy.virtualHosts."monitoring.service.isnt-a.top".extraConfig = ''
    log {
      output file /var/log/caddy/monitoring.service.isnt-a.top-access.log
    }

    reverse_proxy localhost:4000
  '';
}
