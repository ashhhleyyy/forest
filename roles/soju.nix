{ pkgs, config, ... }:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.net.isnt-a.top".directory;
in

{
  services.soju = {
    enable = true;
    # listen only over tailscale
    listen = [
      "irc+insecure://100.97.123.128"
      "ircs://0.0.0.0"
    ];
    adminSocket.enable = true;
    # we store in the db
    enableMessageLogging = false;
    extraConfig = ''
      message-store db
    '';
    tlsCertificate = "${tls-dir}/fullchain.pem";
    tlsCertificateKey = "${tls-dir}/key.pem";
  };

  networking.firewall.allowedTCPPorts = [ 6697 ];

  environment.systemPackages = with pkgs; [
    soju
  ];
}
