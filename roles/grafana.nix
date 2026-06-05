{ pkgs, config, ... }: {
  age.secrets.grafana-secret-key = {
    file = ../secrets/grafana-secret-key.age;
    owner = "grafana";
    group = "grafana";
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3010;
        domain = "grafana.service.isnt-a.top";
        root_url = "https://grafana.service.isnt-a.top";
      };
      security.secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
    };
  };

  forest.backups.paths = [ "/var/lib/grafana" ];
}
