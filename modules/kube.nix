{ config
, lib
, pkgs
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
    age.secrets.k3s-token.file = lib.mkIf (cfg.role == "server") ../secrets/k3s-token.age;

    environment.systemPackages = lib.mkMerge [
      [ pkgs.nfs-utils ]
      (lib.mkIf (cfg.role == "server") [pkgs.kubernetes-helm])
    ];

    services.k3s = {
      enable = true;
      role = cfg.role;
      tokenFile = lib.mkIf (cfg.role == "server") config.age.secrets.k3s-token.path;
      clusterInit = lib.mkIf (cfg.role == "server") true;
      serverAddr = cfg.serverAddr;
      extraFlags = lib.mkIf (cfg.role == "server") ["--disable=traefik" "--cluster-cidr=10.42.0.0/16,2001:cafe:42::/56" "--service-cidr=10.43.0.0/16,2001:cafe:43::/112"];
    };

    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
  };
}
