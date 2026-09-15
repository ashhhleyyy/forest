{ config, lib, ... }:

let
  cfg = config.forest.services.forgejo;
in

{
  options.forest.services.forgejo = {
    enable = lib.mkEnableOption "forgejo";
    hostname = lib.mkOption {
      type = lib.types.str;
    };
    email = {
      from = lib.mkOption {
        type = lib.types.str;
      };
      reply-to = lib.mkOption {
        type = lib.types.str;
      };
      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Age file the email account password is loaded from.
        '';
      };
    };
    caddy.enable = lib.mkEnableOption "forgejo caddy vhost";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.forgejo-mailer-password = {
      file = cfg.email.passwordFile;
      mode = "400";
      owner = "forgejo";
    };

    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = cfg.hostname;
          ROOT_URL = "https://${cfg.hostname}/";
          HTTP_PORT = 3002;
          SSH_PORT = 22;
        };
        service = {
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          ENABLE_NOTIFY_MAIL = true;
          REGISTER_EMAIL_CONFIRM = true;
        };
        "service.explore" = {
          REQUIRE_SIGNIN_VIEW = true;
        };
        repository = {
          USE_COMPAT_SSH_URI = false;
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        mailer = {
          ENABLED = true;
          SMTP_ADDR = "smtp.migadu.com";
          SMTP_PORT = 465;
          FROM = cfg.email.from;
          USER = cfg.email.from;
        };
        "email.incoming" = {
          ENABLED = true;
          REPLY_TO_ADDRESS = cfg.email.reply-to;
          HOST = "imap.migadu.com";
          PORT = 993;
          USE_TLS = true;
          USERNAME = cfg.email.from;
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "login";
        };
      };
      secrets = {
        mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
        "email.incoming".PASSWORD = config.age.secrets.forgejo-mailer-password.path;
      };
      dump = {
        enable = true;
        interval = "03:31";
        type = "tar.zst";
      };
    };

    services.caddy.virtualHosts.${cfg.hostname}.extraConfig = lib.mkIf cfg.caddy.enable ''
      reverse_proxy 127.0.0.1:3002
      import errors
    '';

    forest.backups.paths = [ config.services.forgejo.dump.backupDir ];
  };
}
