{
  config,
  lib,
  utils,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types mkIf optionalAttrs;
    inherit (utils.systemdUtils.unitOptions) unitOption;
  cfg = config.forest.backups;
in

{
  options.forest.backups = {
    enable = mkEnableOption "restic";

    paths = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = lib.mdDoc ''
        Which paths to backup. If null or an empty array, no
        backup command will be run. This can be used to create a
        prune-only job.
      '';
      example = ["/var/lib/postgresql" "/home/user/backup"];
    };

    exclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Patterns to exclude when backing up.
      '';
      example = ["/var/cache" "/home/*/.cache" ".git"];
    };

    timerConfig = mkOption {
      type = types.attrsOf unitOption;
      default = {
        OnCalendar = "*-*-* 4:00:00";
      };
      description = lib.mdDoc ''
        When to run the backup. See man systemd.timer for details.
      '';
      example = {
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };

    personal = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
      Limits the minimum run interval to 12h and only allows the job to run when connected to AC power.
      '';
    };
  };

  # somewhat inspired by https://github.com/diogotcorreia/dotfiles/blob/f49cda185cef30d8150a08b60112766f4fc95813/modules/services/restic.nix
  # lots of stuff here is hardcoded to my setup though
  config = mkIf cfg.enable (let
  in
  {
    age.secrets."restic-key-${config.networking.hostName}".file = ../secrets/restic-key-${config.networking.hostName}.age;
    age.secrets."restic-rclone-${config.networking.hostName}".file = ../secrets/restic-rclone-${config.networking.hostName}.age;
    age.secrets."restic-password-${config.networking.hostName}".file = ../secrets/restic-password-${config.networking.hostName}.age;

    services.restic.backups.forest-backup = {
      repository = "rclone:backupserver:.";
      initialize = true;
      rcloneConfig = {
        type = "sftp";
        key_file = config.age.secrets."restic-key-${config.networking.hostName}".path;
      };
      rcloneConfigFile = config.age.secrets."restic-rclone-${config.networking.hostName}".path;
      passwordFile = config.age.secrets."restic-password-${config.networking.hostName}".path;

      pruneOpts =
        [
          "--keep-last 20"
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
          "--keep-yearly 3"
        ];
      checkOpts = [
        # ensure data integrity
        "--read-data-subset=2.5%"
      ];
      timerConfig = cfg.timerConfig;

      paths = cfg.paths;
      exclude = cfg.exclude;
    };

    systemd.services.restic-backups-forest-backup =
      {
        # Only run when network is up
        wants = ["network-online.target"];
        after = ["network-online.target"];
      }
      // optionalAttrs (cfg.personal) {
        # Configure backups for personal machines
        # Only on AC (for laptops) and never more frequently than 12h
        startLimitIntervalSec = 12 * 60 * 60; # 12h
        startLimitBurst = 1;
        unitConfig.ConditionACPower = "|true"; # | means trigger
      };
  });
}
