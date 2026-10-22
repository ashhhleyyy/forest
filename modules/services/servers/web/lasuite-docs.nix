{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.lasuite-docs;
in

{
  options.forest.services.lasuite-docs = {
    enable = lib.mkEnableOption "lasuite docs";
    domain = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.lasuite-docs-env.file = ../../../../secrets/lasuite-docs-env.age;
    
    services.lasuite-docs = {
      enable = true;
      postgresql.createLocally = true;
      redis.createLocally = true;
      domain = cfg.domain;
      s3Url = "https://s3-garage.service.isnt-a.top/docs-media";
      environmentFile = config.age.secrets.lasuite-docs-env.path;
      settings = {
        DJANGO_ALLOWED_HOSTS = cfg.domain;

        AWS_S3_ENDPOINT_URL = "https://s3-garage.service.isnt-a.top";
        AWS_S3_REGION_NAME = "garage";
        AWS_STORAGE_BUCKET_NAME = "docs-media";

        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://sso.ashhhleyyy.dev/ui/oauth2";
        OIDC_OP_JWKS_ENDPOINT = "https://sso.ashhhleyyy.dev/oauth2/openid/docs/public_key.jwk";
        OIDC_OP_TOKEN_ENDPOINT = "https://sso.ashhhleyyy.dev/oauth2/token";
        OIDC_OP_USER_ENDPOINT = "https://sso.ashhhleyyy.dev/oauth2/openid/docs/userinfo";
        OIDC_RP_CLIENT_ID = "docs";
        OIDC_CREATE_USER = true;

        SECURE_SSL_REDIRECT = false; # our proxy does this, and without, api endpoints continually 301 to themselves

        LOGIN_REDIRECT_URL = "https://docs.ashhhleyyy.dev";
      };
    };
    services.nginx.virtualHosts.${cfg.domain} = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 4440;
        }
        {
          addr = "[::]";
          port = 4440;
        }
      ];
      locations."/api" = {
        recommendedProxySettings = lib.mkForce false;
        extraConfig = ''
        proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $hostname;
        '';
      };
      locations."/admin" = {
        recommendedProxySettings = lib.mkForce false;
        extraConfig = ''
        proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $hostname;
        '';
      };
    };
  };
}
