{ pkgs, config, ... }: {
  services.caddy = {
    enable = true;
    email = "shorks@ashhhleyyy.dev";

    globalConfig = ''
      servers {
        metrics
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
        root * /var/www/shorks-gay
        file_server
        respond /.git/* 404
        respond /cat "nya"
        reverse_proxy /.well-known/webfinger 127.0.0.1:3000
        header /.well-known/matrix/* Content-Type application/json
        header /.well-known/matrix/* Access-Control-Allow-Origin *
        redir /authorize_interaction https://fedi.shorks.gay{uri}

        log {
          output file /var/log/caddy/shorks.gay-access.log
        }

        import blockbots
        import errors
      '';

      "gerrit.shorks.gay".extraConfig = ''
        reverse_proxy 100.123.36.114:8082

        log {
          output file /var/log/caddy/gerrit.shorks.gay-access.log
        }
      '';

      "http://${config.networking.hostName}.ash.ley:9101".extraConfig = ''
        metrics
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 29418 ];
}
