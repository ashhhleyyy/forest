{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/generic.nix
    ../../common/server.nix
    ../../common/tailscale.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "amy";
  networking.domain = "serv.ashhhleyyy.dev";

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  console.keyMap = "uk";

  nix.settings.trusted-users = [ "@wheel" ];

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "23.11";
}
