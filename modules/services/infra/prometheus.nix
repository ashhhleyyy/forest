{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.prometheus;
in

{
  options.forest.services.prometheus = {
    enable = lib.mkEnableOption "prometheus";
  };

  config = lib.mkIf cfg.enable {
    # TODO: look into spliting up this config and settin options nearer the services doing the exporting on each host
    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "prometheus";
          scrape_interval = "60s";
          static_configs = [
            {
              targets = ["localhost:9090"];
            }
          ];
        }
        {
          job_name = "node_exporter";
          scrape_interval = "30s";
          static_configs = [
            {
              targets = [
                "jessica.bun-galaxy.ts.net:9100"
                "amy.bun-galaxy.ts.net:9100"
                "fern.bun-galaxy.ts.net:9100"
                "loona.bun-galaxy.ts.net:9100"
              ];
            }
          ];
        }
        {
          job_name = "systemd_exporter";
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [
                "jessica.bun-galaxy.ts.net:9558"
                "amy.bun-galaxy.ts.net:9558"
                "fern.bun-galaxy.ts.net:9558"
                "loona.bun-galaxy.ts.net:9558"
              ];
            }
          ];
        }
        {
          job_name = "postgres";
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [
                "jessica.bun-galaxy.ts.net:9187"
                "amy.bun-galaxy.ts.net:9187"
              ];
            }
          ];
        }
        {
          job_name = "iocaine";
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [
                "amy.bun-galaxy.ts.net:42042"
              ];
            }
          ];
        }

        {
          job_name = "caddy";
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [
                "amy.bun-galaxy.ts.net:9101"
              ];
            }
          ];
        }
      ];
    };
  };
}
