{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  forest = {
    boot.grub.enable = true;
    profiles.server.enable = true;
    tools.podman.enable = true;
  };

  services.smartd.enable = true;
  
  networking.hostName = "lea";

  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    smartmontools
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.11";
}
