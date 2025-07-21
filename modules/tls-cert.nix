{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.forest.tls-cert;
in

{
  options.forest.tls-cert = {
    enable = mkEnableOption "tls-cert";
  };

  config = mkIf cfg.enable {
    age.secrets."servfail-token".file = ../secrets/servfail-token.age;

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
