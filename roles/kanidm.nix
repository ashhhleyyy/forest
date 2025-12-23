{ config, pkgs, ... }:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.net.isnt-a.top".directory;
in

{
  services.kanidm = {
    package = pkgs.kanidm_1_8;

    enableServer = true;
    serverSettings = {
      version = "2";
      bindaddress = "[::]:3006";
      ldapbindaddress = "[::]:3636";
      tls_chain = "${tls-dir}/fullchain.pem";
      tls_key = "${tls-dir}/key.pem";
      log_level = "info";
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

  users.users.kanidm.extraGroups = ["acme"];

  forest.backups.paths = ["/var/lib/kanidm/backups/"];
}
