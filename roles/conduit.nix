{ pkgs, ... }: {
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "shorks.gay";
        database_backend = "rocksdb";
        allow_check_for_updates = true;
        address = "::";
      };
    };
  };

  services.caddy.virtualHosts = {
    "matrix.shorks.gay".extraConfig = ''
      reverse_proxy 127.0.0.1:6167

      log {
        output file /var/log/caddy/matrix.shorks.gay-access.log
      }
    '';

    "schildi.shorks.gay".extraConfig = ''
      root * /var/www/schildichat-web
      file_server

      log {
        output file /var/log/caddy/schildi.shorks.gay-access.log
      }
    '';

    "cinny.shorks.gay".extraConfig = ''
      root * /var/www/cinny
      file_server

      log {
        output file /var/log/caddy/cinny.shorks.gay-access.log
      }
    '';
  };
}
