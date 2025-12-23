{ config, pkgs, ... }:

{
  age.secrets."garage-rpc-secret".file = ../secrets/garage-rpc-secret.age;
  age.secrets."garage-admin-token".file = ../secrets/garage-admin-token.age;

  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    settings = {
      replication_factor = 1;
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";
      rpc_secret_file = "/run/credentials/garage.service/rpc-secret"; # ;
      s3_api = {
        s3_region = "garage";
        api_bind_addr = "[::]:3900";
        root_domain = "s3-garage.service.isnt-a.top";
      };
      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = "web-garage.service.isnt-a.top";
        index = "index.html";
      };
      admin = {
        api_bind_addr = "[::]:3903";
        admin_token_file = "/run/credentials/garage.service/admin-token";
      };
    };
  };

  systemd.services.garage.serviceConfig = {
    LoadCredential = [
      "rpc-secret:${config.age.secrets."garage-rpc-secret".path}"
      "admin-token:${config.age.secrets."garage-admin-token".path}"
    ];
  }

  forest.backups.paths = [ "/var/lib/garage" ];
}
