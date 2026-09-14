{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "jessica";
  networking.domain = "net.isnt-a.top";

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  networking = {
    interfaces = {
      ens18 = {
        ipv6.addresses = [{
          address = "2a02:c202:2235:8198:0000:0000:0000:0001";
          prefixLength = 64;
        }];
      };
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };
  services.resolved.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];
  services.caddy = {
    enable = true;
    email = "infra@ashhhleyyy.dev";
  };

  forest = {
    backups.enable = true;
    common.deploy-user.enable = true;
    profiles.server.enable = true;
    services = {
      cryptpad = {
        enable = true;
        origins = {
          safe = "https://cryptpad-sandbox.ashhhleyyy.dev";
          unsafe = "https://cryptpad.ashhhleyyy.dev";
        };
        adminKeys = [
          "[ash@cryptpad.ashhhleyyy.dev/ShpVAzqTPFZuqGhyhqpjBc3fUr4GBhUcaJEUmZqPzOg=]"
        ];
      };
      docker-registry.enable = true;
      garage = {
        enable = true;
        domains = {
          s3 = "s3-garage.service.isnt-a.top";
          web = "sites.ashhhleyyy.dev";
        };
        secrets = {
          rpc = ../../secrets/garage-rpc-secret.age;
          adminToken = ../../secrets/garage-admin-token.age;
        };
      };
      git-in.enable = true;
      grafana = {
        enable = true;
        hostname = "grafana.service.isnt-a.top";
        renderer.enable = true;
      };
      immich.enable = true;
      jenkins.enable = true;
      kanidm = {
        server = {
          enable = true;
          origin = "https://sso.ashhhleyyy.dev";
        };
        client.enable = true;
      };
      kube = {
        enable = true;
        role = "server";
      };
      livekit = {
        enable = true;
        keyFile = ../../secrets/livekit-keys.age;
      };
      mumble.enable = true;
      munin = {
        enable = true;
        server = {
          enable = true;
          nodes = {
            amy = "amy.bun-galaxy.ts.net";
          };
        };
      };
      node-red.enable = true;
      pds = {
        enable = true;
        hostname = "pds.ashhhleyyy.dev";
        environmentFile = ../../secrets/pds-env.age;
      };
      postgresql = {
        enable = true;
        package = pkgs.postgresql_18;
        settings = import ./postgres-tuning.nix;
        databases = [
          "railing_it"
        ];
        users = [{
          ensureDBOwnership = true;
          name = "railing_it";
        }];
        extensions = ps: [ps.postgis];
      };
      prometheus.enable = true;
      reposilite.enable = true;
      soju.enable = true;
      uptime-kuma.enable = true;
      tailscale.enable = true;
      vaultwarden = {
        enable = true;
        environmentFile = ../../secrets/vaultwarden.age;
      };
    };
    tools.podman.enable = true;
    util.tls-cert.enable = true;
  };

  system.stateVersion = "24.11";
}
