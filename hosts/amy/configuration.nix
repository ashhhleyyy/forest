{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/generic.nix
    ../../common/server.nix
    ../../common/tailscale.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "amy";
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
  networking.firewall.allowedTCPPorts = [ 22 ];

  networking = {
    interfaces = {
      ens18 = {
        # ipv4.addresses = [{
        #   address = "45.136.19.220";
        #   prefixLength = 23;
        # }];
        ipv6.addresses = [{
          address = "2a02:c202:2191:6731:0000:0000:0000:0001";
          prefixLength = 64;
        }];
      };
    };
    # defaultGateway = "162.244.28.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };

    # networking.nameservers = [
    #   "1.1.1.1"
    #   "1.0.0.1"
    #   "9.9.9.9"
    #   "149.112.112.112"
    #   "2606:4700:4700::1111"
    #   "2606:4700:4700::1001"
    #   "2620:fe::fe"
    #   "2620:fe::9"
    # ];
  };
  services.resolved.enable = true;

  services.aci-backend.enable = true;
  forest.backups.paths = [ "/var/lib/private/aci-backend" ];

  forest.backups.enable = true;

  system.stateVersion = "23.11";
}
