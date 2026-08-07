{ pkgs, config, ... }: {
  age.secrets.grafana-secret-key = {
    file = ../secrets/grafana-secret-key.age;
    owner = "grafana";
    group = "grafana";
  };
  age.secrets.grafana-renderer-token = {
    file = ../secrets/grafana-renderer-token.age;
    owner = "grafana";
    group = "grafana";
  };
  age.secrets.grafana-renderer-environ.file = ../secrets/grafana-renderer-environ.age;

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
      rendering.renderer_token = "$__file{${config.age.secrets.grafana-renderer-token.path}}";
    };
  };

  services.grafana-image-renderer = {
    enable = true;
    provisionGrafana = true;
  };

  systemd.services.grafana-image-renderer.serviceConfig.EnvironmentFile = config.age.secrets.grafana-renderer-environ.path;

  forest.backups.paths = [ "/var/lib/grafana" ];
}
