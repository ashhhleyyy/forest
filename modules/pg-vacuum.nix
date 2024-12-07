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
      type = types.listOf types.string;
      default = [];
      description = ''
      List of databases to perform the vacuuming on. Must not be empty if enable is set to true.
      '';
    };
    frequency = mkOption {
      type = types.string;
      default = "1d";
      description = ''
      The interval between vacuum runs, '1d' is the recommended value.

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
      };
      ExecStart = ''
        ${vacuumScript} ${utils.escapeSystemdExecArgs cfg.databases}
      '';
    };
  };
}
