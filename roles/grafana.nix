{ pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3010;
        domain = "grafana.service.isnt-a.top";
        root_url = "https://grafana.service.isnt-a.top";
      };
    };
  };

  services.caddy.virtualHosts."grafana.service.isnt-a.top".extraConfig = ''
    reverse_proxy localhost:3010
  '';
}
