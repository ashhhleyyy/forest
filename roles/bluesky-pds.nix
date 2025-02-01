{ pkgs, config, ... }: {  
  age.secrets."pds-env".file = ../secrets/pds-env.age;

  services.pds = {
    enable = true;
    pdsadmin.enable = true;
    settings = {
      PDS_HOSTNAME = "pds.ashhhleyyy.dev";
    };
    environmentFiles = [
      config.age.secrets.pds-env.path
    ];
  };

  services.caddy = {
    # TODO: migrate to wildcard cert rather than on demand tls
    globalConfig = ''
      on_demand_tls {
        ask http://localhost:3000/tls-check
      }
    '';

    virtualHosts."pds.ashhhleyyy.dev" = {
      serverAliases = [
        "*.pds.ashhhleyyy.dev"
      ];
      extraConfig = ''
        tls {
          on_demand
        }
        reverse_proxy http://localhost:3000
      '';
    };
  };
}
