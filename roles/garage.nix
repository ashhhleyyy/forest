{ config, pkgs, ... }:

{
  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    settings = {
      replication_factor = 1;
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";
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
      };
    };
  };

  forest.backups.paths = [ "/var/lib/garage" ];
}
