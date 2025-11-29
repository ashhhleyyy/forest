{ config
, pkgs
, ...
}:
{
  services.immich = {
    enable = true;
  };

  services.postgresqlBackup.databases = ["immich"];
  forest.backups.paths = [ "/var/lib/immich" ];
}
