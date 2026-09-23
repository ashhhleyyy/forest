{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.shorks-web;
in

{
  options.forest.services.shorks-web = {
    enable = lib.mkEnableOption "shorks-web";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = "shorks@ashhhleyyy.dev";

      globalConfig = ''
        metrics {
          per_host
        }
      '';

      extraConfig = ''
        (blockbots) {
          respond @badbots "Fuck you" 410 {
            close
          }

          @badbots {
            header User-Agent *QQDownload*
            header User-Agent *TencentTraveler*
            header User-Agent *Bytespider*
            header User-Agent *FediList*
            header User-Agent *oii-research*
            header User-Agent *openai*
            header User-Agent *LivelapBot*
            header User-Agent *ClaudeBot*
          }
        }

        (errors) {
          handle_errors {
            @502 `{err.status_code} in [502]`
            handle @502 {
              rewrite * /{err.status_code}.html
              #rewrite * /maintenance.html
              root * /var/www/shorks-gay
              file_server {
                status 502
              }
            }
          }
        }
      '';

      virtualHosts = {
        "shorks.gay".extraConfig = ''
          import iocaine

          root * /var/www/shorks-gay
          file_server
          respond /.git/* 404
          respond /cat "nya"
          reverse_proxy /.well-known/webfinger 127.0.0.1:3000
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          redir /authorize_interaction https://fedi.shorks.gay{uri}

          import errors
        '';

        "http://${config.networking.hostName}.bun-galaxy.ts.net:9101".extraConfig = ''
          metrics
        '';
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
      29418
    ];
  };
}
