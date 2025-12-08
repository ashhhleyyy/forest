{ config
, pkgs
, ...
}:
{
  services.immich = {
    enable = true;
    database.enableVectors = false;
    host = "::";
    machine-learning.environment = {
      IMMICH_PORT = "3007";
    };
  };

  services.postgresqlBackup.databases = ["immich"];
  forest.backups.paths = [ "/var/lib/immich" ];
}
