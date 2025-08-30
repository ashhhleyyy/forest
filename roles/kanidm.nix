{ config, pkgs, ... }:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.net.isnt-a.top".directory;
in

{
  services.kanidm = {
    enableServer = true;
    serverSettings = {
      bindaddress = "[::]:3006";
      ldapbindaddress = "[::]:3636";
      tls_chain = "${tls-dir}/fullchain.pem";
      tls_key = "${tls-dir}/key.pem";
      log_level = "default";
      domain = "sso.ashhhleyyy.dev";
      origin = "https://sso.ashhhleyyy.dev";
      role = "WriteReplica";
      http_client_address_info."x-forward-for" = [];
      online_backup = {
        path = "/var/lib/kanidm/backups/";
        schedule = "0 3 * * *";
        versions = 7;
      };
    };

    enableClient = true;

    clientSettings = {
      uri = "https://sso.ashhhleyyy.dev";
    };
  };
}
