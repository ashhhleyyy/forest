{ config, lib, ... }:

let
  cfg = config.forest.services.grafana;
in

{
  options.forest.services.grafana = {
    enable = lib.mkEnableOption "grafana";
    hostname = lib.mkOption {
      description = "Hostname for this grafana instance";
      type = lib.types.str;
    };
    renderer.enable = lib.mkEnableOption "grafana image renderer";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.grafana-secret-key = {
      file = ../secrets/grafana-secret-key.age;
      owner = "grafana";
      group = "grafana";
    };
    age.secrets.grafana-renderer-token = lib.mkIf cfg.renderer.enable {
      file = ../secrets/grafana-renderer-token.age;
      owner = "grafana";
      group = "grafana";
    };
    age.secrets.grafana-renderer-environ.file = lib.mkIf cfg.renderer.enable ../secrets/grafana-renderer-environ.age;

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3010;
          domain = cfg.hostname;
          root_url = "https://${cfg.hostName}";
        };
        security.secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
        rendering.renderer_token = lib.mkIf cfg.renderer.enable "$__file{${config.age.secrets.grafana-renderer-token.path}}";
      };
    };

    services.grafana-image-renderer = lib.mkIf cfg.renderer.enable {
      enable = true;
      provisionGrafana = true;
    };

    systemd.services.grafana-image-renderer.serviceConfig.EnvironmentFile = lib.mkIf cfg.renderer.enable config.age.secrets.grafana-renderer-environ.path;

    forest.backups.paths = [ "/var/lib/grafana" ];
  };
}
