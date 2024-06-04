{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  networking.hostName = "amy";
  networking.domain = "serv.ashhhleyyy.dev";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
