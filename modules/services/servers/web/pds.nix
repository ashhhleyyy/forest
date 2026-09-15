{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.pds;
in

{
  options.forest.services.pds = {
    enable = lib.mkEnableOption "pds";
    hostname = lib.mkOption {
      description = "Public hostname of the PDS instance";
      type = lib.types.str;
    };
    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Age file the PDS service environment is loaded from.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."pds-env".file = cfg.environmentFile;

    services.bluesky-pds = {
      enable = true;
      pdsadmin.enable = true;
      settings = {
        PDS_HOSTNAME = cfg.hostname;
      };
      environmentFiles = [
        config.age.secrets.pds-env.path
      ];
    };

    forest.backups.paths = [ "/var/lib/pds" ];
  };
}
