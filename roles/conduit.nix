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
    '';

    "schildi.shorks.gay".extraConfig = ''
      root * /var/www/schildichat-web
      file_server
    '';

    "cinny.shorks.gay".extraConfig = ''
      root * /var/www/cinny
      file_server
    '';
  };

  forest.backups.paths = [ "/var/lib/private/matrix-conduit" ];
}
