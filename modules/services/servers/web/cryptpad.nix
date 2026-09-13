{ config, lib, ... }:

let
  cfg = config.forest.services.cryptpad;
in

{
  options.forest.services.cryptpad = {
    enable = lib.mkEnableOption "cryptpad";
    origins = {
      safe = lib.mkOption {
        type = lib.types.str;
      };
      unsafe = lib.mkOption {
        type = lib.types.str;
      };
    };
    adminKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
      settings = {
        httpSafeOrigin = cfg.origins.safe;
        httpUnsafeOrigin = cfg.origins.unsafe;
        blockDailyCheck = true;
        httpPort = 3002;
        websocketPort = 3003;
        httpAddress = "0.0.0.0"; # this is fine because firewall lol
        adminKeys = cfg.adminKeys;
        maxUploadSize = 200 * 1024 * 1024;
      };
    };

    forest.backups.paths = [ "/var/lib/private/cryptpad" ];
  };
}
