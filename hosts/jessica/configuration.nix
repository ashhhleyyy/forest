{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/generic.nix
    ../../common/server.nix
    ../../common/tailscale.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "jessica";
  networking.domain = "net.isnt-a.top";

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  #services.xserver = {
  #  layout = "gb";
  #  xkbVariant = "";
  #};

  console.keyMap = "uk";

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
#  networking.firewall.allowedTCPPorts = [ 22 ];

  networking = {
    interfaces = {
      ens18.ipv6.addresses = [{
        address = "2a02:c202:2235:8198:0000:0000:0000:0001";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };
  services.resolved.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    email = "infra@ashhhleyyy.dev";
  };

  forest.kube = {
    enable = true;
    role = "server";
  };

  system.stateVersion = "24.11";
}
