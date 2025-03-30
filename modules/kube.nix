{ config
, lib
, ...
}:

let
  cfg = config.forest.kube;
in

{
  options.forest.kube = {
    enable = lib.mkEnableOption {};

    role = lib.mkOption {
      default = "agent";

      type = lib.types.enum [
        "server"
        "agent"
      ];
    };

    serverAddr = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.k3s-token.file = mkIf (cfg.role == "server") ../secrets/k3s-token.age;

    services.k3s = {
      enable = true;
      role = cfg.role;
      tokenFile = mkIf (cfg.role == "server") config.age.secrets.k3s-token.path;
      clusterInit = mkIf (cfg.role == "server") true;
      serverAddr = cfg.serverAddr;
    };
  };
}
