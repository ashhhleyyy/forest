{
  config,
  lib,
  ...
}:
let
  cfg = config.forest.util.tls-cert;
in

{
  options.forest.util.tls-cert = {
    enable = lib.mkEnableOption "tls-cert";
  };

  config = lib.mkIf cfg.enable {
    age.secrets."servfail-token".file = ../../secrets/servfail-token.age;

    security.acme = {
      acceptTerms = true;
      defaults.email = "infra@ashhhleyyy.dev";
      certs."${config.networking.hostName}.net.isnt-a.top" = {
        extraDomainNames = [
          "*.${config.networking.hostName}.net.isnt-a.top"
        ];
        dnsProvider = "pdns";
        environmentFile = config.age.secrets."servfail-token".path;
        dnsPropagationCheck = true;
      };
    };
  };
}
