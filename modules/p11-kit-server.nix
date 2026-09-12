{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.p11-kit-server;
in

{
  options.services.p11-kit-server = {
    enable = lib.mkEnableOption {};
    package = lib.mkPackageOption pkgs "p11-kit" {};
  };

  config = lib.mkIf cfg.enable {
    systemd.user.sockets.p11-kit-server = {
      description = "p11-kit server";
      wantedBy = ["sockets.target"];
      listenStreams = ["%t/p11-kit/pkcs11"];
      socketConfig = {
        Priority = "6";
        Backlog = "5";
        SocketMode = "0600";
      };
    };
    systemd.user.services.p11-kit-server = {
      description = "p11-kit server";
      documentation = ["man:p11-kit(8)"];
      requires = ["p11-kit-server.socket"];
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "simple";
        StandardError = "journal";
        ExecStart = "${cfg.package}/libexec/p11-kit/p11-kit-server -f -n %t/p11-kit/pkcs11 pkcs11:";
        Restart = "on-failure";
      };
    };
  };
}
