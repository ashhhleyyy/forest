{ config, lib, ... }:

let
  cfg = config.forest.services.guacamole;

  guacVer = config.services.guacamole-client.package.version;
  pgsqlVer = "42.7.15";

  pgsqlDriverSrc = pkgs.fetchurl {
    url = "https://jdbc.postgresql.org/download/postgresql-${pgsqlVer}.jar";
    sha256 = "sha256-SbupwyANT2Suc5A9Vs4b0Jx0UX3+May0R0VQa0/O3lM=";
  };

  pgsqlExtension = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-jdbc-postgresql-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-jdbc-${guacVer}.tar.gz";
      sha256 = "sha256-9Fc2so62ZHt+sNK0gzHhLlpDJmH2ERW2PRoFpb0gJE0=";
    };
    phases = "unpackPhase installPhase";
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp -r guacamole-auth-jdbc-${guacVer}/postgresql/* $out
    '';
  };

  oidcExtension = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-sso-openid-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-sso-${guacVer}.tar.gz";
      sha256 = "sha256-2Kptu0yRBPbF+reEOyO1DDK4RPZ8lTTjFrjQ5d+M/Oo=";
    };
    phases = "unpackPhase installPhase";
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp guacamole-auth-sso-${guacVer}/openid/guacamole-auth-sso-openid-${guacVer}.jar $out
    '';
  };

  psql = "${pkgs.postgresql}/bin/psql";
  cat = "${pkgs.coreutils-full}/bin/cat";
in

{
  options.forest.services.guacamole = {
    enable = lib.mkEnableOption "guacamole";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.guacamole-properties = lib.mkIf cfg.renderer.enable {
      file = ../../../../secrets/guacamole-properties.age;
      path = "/etc/guacamole/guacamole.properties";
    };

    services = {
      guacamole-server = {
        enable = true;
      };
      guacamole-client = {
        enable = true;
        settings = {
          guacd-hostname = "127.0.0.1";
          guacd-port = 4822;
          extension-priority = "*, openid";
          postgresql-hostname = "localhost";
          postgresql-database = "guacamole";
          postgresql-username = "guacamole";
          postgresql-password = "guacamole";
          openid-authorization-endpoint = "https://sso.ashhhleyyy.dev/ui/oauth2";
          openid-client-id = "redacted";
          openid-issuer = "https://sso.ashhhleyyy.dev/oauth2/openid/guacamole";
          openid-jwks-endpoint = "https://sso.ashhhleyyy.dev/oauth2/openid/guacamole/public_key.jwk";
          openid-redirect-uri = "https://guacamole.ashhhleyyy.dev/";
        };
      };
    };

    forest.services.postgresql = {
      databases = ["guacamole"];
      users = [
        {
          name = "guacamole";
          ensureDBOwnership = true;
        }
      ];
    };

    environment.etc."guacamole/extensions/guacamole-auth-sso-openid-${guacVer}.jar".source =
      "${oidcExtension}/guacamole-auth-sso-openid-${guacVer}.jar";

    environment.etc."guacamole/lib/postgresql-${pgsqlVer}.jar".source = pgsqlDriverSrc;

    environment.etc."guacamole/extensions/guacamole-auth-jdbc-postgresql-${guacVer}.jar".source =
      "${pgsqlExtension}/guacamole-auth-jdbc-postgresql-${guacVer}.jar";

    systemd.services."guacamole-pgsql-schema-import" = {
      enable = true;
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      wantedBy = [
        "tomcat.service"
        "multi-user.target"
      ];
      script = ''
        echo "[guacamole-bootstrapper] Info: checking if database 'guacamole' exists but is empty..."
        output=$(${psql} -U guacamole -c "\dt" 2>&1)
        if [[ $output == "Did not find any relations." ]]; then
          echo "[guacamole-bootstrapper] Info: installing guacamole postgres database schema..."
          ${cat} ${pgsqlExtension}/schema/*.sql | ${psql} -U guacamole -d guacamole -f -
        fi
      '';
    };

    systemd.services.tomcat = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}
