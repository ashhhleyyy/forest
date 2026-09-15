{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "amy";
  networking.domain = "net.isnt-a.top";

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  networking = {
    interfaces = {
      ens18 = {
        ipv6.addresses = [
          {
            address = "2a02:c202:2191:6731:0000:0000:0000:0001";
            prefixLength = 64;
          }
        ];
      };
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };
  services.resolved.enable = true;

  services.aci-backend.enable = true;
  forest = {
    backups = {
      enable = true;
      paths = [ "/var/lib/private/aci-backend" ];
    };
    common.deploy-user.enable = true;
    profiles.server.enable = true;
    services = {
      conduit = {
        enable = true;
        serverName = "shorks.gay";
        frontends.enable = true;
      };
      forgejo = {
        enable = true;
        hostname = "git.eduwoem.org";
        email = {
          from = "eduwoem-git@ashhhleyyy.dev";
          reply-to = "eduwoem-git+%{token}@ashhhleyyy.dev";
          passwordFile = ../../secrets/forgejo-mailer-password.age;
        };
        # caddy.enable = true;
      };
      gotosocial = {
        enable = true;
        host = "sandbox.isnt-a.top";
        caddy.enable = true;
      };
      iceshrimp-js = {
        enable = true;
        caddy.enable = true;
      };
      itwont-work.enable = true;
      keycloak = {
        enable = true;
        authCaFile = ./keycloak-auth-ca.pem;
        caddy.enable = true;
        hostname = "account.shorks.gay";
        passwordFile = ../../secrets/keycloak-postgres-password.age;
      };
      munin.enable = true;
      pg-vacuum.enable = true;
      postgresql = {
        enable = true;
        package = pkgs.postgresql_18;
        settings = import ./postgres-tuning.nix;
        databases = [ "shorks-gay" ];
      };
      shorks-web = {
        enable = true;
        openFirewall = true;
      };
      tailscale.enable = true;
    };
    tools.podman.enable = true;
  };

  system.stateVersion = "23.11";
}
