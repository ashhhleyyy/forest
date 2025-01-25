{ pkgs, lib, config, utils, ... }:

with lib;

let
  cfg = config.services.pg-vacuum;
  vacuumScript = pkgs.writeShellScript "vacuum-postgresql-databases" ''
  set -eu -o pipefail

  for database in "$@"
  do
      echo "Vacuuming $database..."
      echo 'VACUUM ANALYZE;' | psql $database
      echo "Finished vacuuming $database"
  done
  '';
in
{
  options.services.pg-vacuum = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
      Enable the PostgreSQL vacuum service and timer.
      services.postgresql.enable must also be set to true.
      '';
    };
    package = mkPackageOption pkgs "postgresql" {
      example = "postgresql_15";
    };
    databases = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
      List of databases to perform the vacuuming on. Must not be empty if enable is set to true.
      '';
    };
    onCalendar = mkOption {
      type = types.str;
      default = "*-*-* 2:00:00";
      description = ''
      The interval between vacuum runs, the default value runs the vacuum job every day at 4am.

      The format is described in systemd.time(7).
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = ((builtins.length cfg.databases) != 0);
        message = "'services.pg-vacuum.databases' must not be empty";
      }
    ];

    systemd.services.pg-vacuum = {
      description = "Vacuum PostgreSQL databases";
      path = [ cfg.package ];
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
        Group = "postgres";
        ExecStart = ''
          ${vacuumScript} ${utils.escapeSystemdExecArgs cfg.databases}
        '';
      };
    };

    systemd.timers.pg-vacuum = {
      description = "Vacuum PostgreSQL databases";
      wantedBy = ["timers.target"];
      timerConfig = {
        Unit = "pg-vacuum.service";
        OnCalendar = cfg.onCalendar;
        Persistent = true;
      };
    };
  };
}
