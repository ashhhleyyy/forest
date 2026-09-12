{ config, lib, pkgs, ... }: {
  age.secrets.keycloakPostgres.file = ../secrets/keycloakPostgres.age;

  services.keycloak = {
    enable = true;
    package = pkgs.keycloak.overrideAttrs (finalAttrs: previousAttrs: {
      buildPhase = lib.replaceString "bin/kc.sh build" "bin/kc.sh build --spi-x509cert-lookup--provider=rfc9440" previousAttrs.buildPhase;
    });
    themes = {
      shorks = pkgs.fetchgit {
        rev = "873ad2e9cd6ce69f28b45b755eff2ffb490e440b";
        url = "https://codeberg.org/ashhhleyyy/shorks-keycloak.git";
        hash = "sha256-nMZbtrVfp8U11qAmt1Bnu/Qf2qBUErxvf5x4ol2SXuQ=";
      };
    };
    plugins = [
      ((pkgs.fetchMavenArtifact {
        groupId = "gay.shorks";
        artifactId = "icecloak";
        version = "1.3.0+kc.26";
        repos = ["https://maven.ashhhleyyy.dev/releases/"];
        hash = "sha256-cxCueVJu+rNx+tObZXDNc2fhzQLoC2w2fX3dw/A3A7I=";
      }).passthru.jar)
    ];
    settings = {
      hostname = "account.shorks.gay";
      http-port = 8008;
      http-enabled = true;
      proxy-headers = "xforwarded";
    };
    database.passwordFile = config.age.secrets.keycloakPostgres.path;
  };

  services.caddy.virtualHosts."account.shorks.gay".extraConfig = ''
    tls {
      client_auth {
        mode verify_if_given
        trust_pool file ${./keycloak/ca.pem}
      }
    }
    vars cert_header ""
    @certavailable vars_regexp {tls_client_certificate_der_base64} .+
    vars @certavailable cert_header ":{tls_client_certificate_der_base64}:"
    reverse_proxy 127.0.0.1:8008 {
      header_up Client-Cert {vars.cert_header}
    }
  '';

  services.postgresqlBackup.databases = ["keycloak"];
}
