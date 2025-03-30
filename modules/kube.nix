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

  config = (lib.mkIf (cfg.enable && cfg.role == "server") {
    age.secrets.k3s-token.file = ../secrets/k3s-token.age;

    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = config.age.secrets.k3s-token.path;
      clusterInit = true;
    };
  }) // (lib.mkIf (cfg.enable && cfg.role == "agent") {
    services.k3s = {
      enable = true;
      role = "agent";
      serverAddr = cfg.serverAddr;
    };
  });
}
