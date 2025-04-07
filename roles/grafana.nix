{ pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3010;
        domain = "grafana.service.isnt-a.top";
        root_url = "https://grafana.service.isnt-a.top";
      };
    };
  };
}
