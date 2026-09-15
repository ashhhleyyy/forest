{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.postgresql;
in

{
  options.forest.services.postgresql = {
    enable = lib.mkEnableOption "postgresql";
    package = lib.mkPackageOption pkgs "postgresql" {
      example = "postgresql_18";
    };
    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.bool
          lib.types.float
          lib.types.int
          lib.types.str
        ]
      );
    };
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    users = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = ''
                Name of the user to ensure.
              '';
            };
            ensureDBOwnership = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Grants the user ownership to a database with the same name.
                This database must be defined manually in
                [](#opt-forest.services.postgresql.databases).
              '';
            };
          };
        }
      );
      default = [ ];
    };
    extensions = lib.mkOption {
      type = with lib.types; coercedTo (listOf path) (path: _ignorePg: path) (functionTo (listOf path));
      default = _: [ ];
      description = ''
        List of PostgreSQL extensions to install.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      settings = cfg.settings;
      ensureDatabases = cfg.databases;
      ensureUsers = cfg.users;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database DBuser  auth-method
        local all      all     peer
        #type database DBuser  origin-address auth-method
        # ipv4
        host  all      all     0.0.0.0/0     scram-sha-256
        # ipv6
        host all       all     ::/0           scram-sha-256
      '';
    };

    forest.services.pg-vacuum.package = cfg.package;

    services.prometheus.exporters.postgres = {
      enable = true;
      runAsLocalSuperUser = true;
    };

    services.postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 03:00:00";
      databases = cfg.databases;
    };

    forest.backups.paths = [ "/var/backup/postgresql" ];
  };
}
