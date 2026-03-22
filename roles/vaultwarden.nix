{ config, pkgs, ... }: {
  age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    domain = "pws.ashhhleyyy.dev";
    config = {
      SIGNUPS_ALLOWED = false;
      SMTP_HOST = "smtp.migadu.com";
      SMTP_SECURITY = "force_tls";
      SMTP_PORT = 465;
      SMTP_FROM = "services@ashhhleyyy.dev";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_USERNAME = "services@ashhhleyyy.dev";
    };
    environmentFile = config.age.secrets.vaultwarden.path;
    backupDir = "/var/backup/vaultwarden";
  };

  forest.backups.paths = [ config.services.vaultwarden.backupDir ];
}
