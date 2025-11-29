{ config
, pkgs
, ...
}:
{
  services.immich = {
    enable = true;
    database.enableVectors = false;
    host = "::";
  };

  services.postgresqlBackup.databases = ["immich"];
  forest.backups.paths = [ "/var/lib/immich" ];
}
