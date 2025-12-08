{ config
, pkgs
, lib
, ...
}:
{
  services.immich = {
    enable = true;
    database.enableVectors = false;
    host = "::";
    machine-learning.environment = {
      IMMICH_PORT = lib.mkForce "3007";
    };
  };

  services.postgresqlBackup.databases = ["immich"];
  forest.backups.paths = [ "/var/lib/immich" ];
}
