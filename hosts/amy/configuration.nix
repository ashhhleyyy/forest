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
      ens18.ipv6.addresses = [{
        address = "2a02:c202:2191:6731:0000:0000:0000:0001";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };
  services.resolved.enable = true;

  services.aci-backend.enable = true;
  forest.backups.paths = [ "/var/lib/private/aci-backend" ];

  forest.backups.enable = true;

  system.stateVersion = "23.11";
}
