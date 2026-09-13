{ config, lib, pkgs, ... }:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.net.isnt-a.top".directory;
  cfg = config.forest.services.soju;
in

{
  options.forest.services.soju = {
    enable = lib.mkEnableOption "soju";
  };

  config = lib.mkIf cfg.enable {
    services.soju = {
      enable = true;
      # listen only over tailscale
      listen = [
        "irc+insecure://100.97.123.128" # TODO: remove
        "ircs://0.0.0.0"
      ];
      hostName = "${config.networking.hostName}.net.isnt-a.top";
      adminSocket.enable = true;
      # we store in the db
      enableMessageLogging = false;
      extraConfig = ''
        message-store db
      '';
      tlsCertificate = "${tls-dir}/fullchain.pem";
      tlsCertificateKey = "${tls-dir}/key.pem";
    };

    systemd.services.soju.serviceConfig.SupplementaryGroups = "acme";

    networking.firewall.allowedTCPPorts = [ 6697 ];

    environment.systemPackages = with pkgs; [
      soju
    ];

    forest.backups.paths = [ "/var/lib/private/soju" ];
  };
}
