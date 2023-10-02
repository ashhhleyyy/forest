{ config, pkgs, ... }: {
  services.kanidm = {
    # enableServer = true;
    # serverSettings = {
    #   bindaddress = "[::]:8443";
    #   ldapbindaddress = "[::]:3636";
    #   # We are behind a reverse proxy
    #   trust_x_forward_for = true;
    #   tls_chain = "";
    #   tls_key = "";
    #   log_level = "default";
    #   domain = "sso.ashhhleyyy.dev";
    #   origin = "https://sso.ashhhleyyy.dev";
    #   role = "WriteReplica";
    # };

    enableClient = true;

    clientSettings = {
      uri = "https://sso.ashhhleyyy.dev";
    };
  };
}
