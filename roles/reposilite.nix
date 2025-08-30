{ pkgs, ... }: {
  services.reposilite = {
    enable = true;
    settings = {
      port = 3005;
    };
    database = {
      type = "sqlite";
      path = "reposilite.db";
    };
  };

  forest.backups.paths = [ "/var/lib/reposilite" ];
}
