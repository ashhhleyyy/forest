{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/generic.nix
      ../../common/server.nix
      ../../common/tailscale.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;

  services.smartd.enable = true;
  
  networking.hostName = "lea";

  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  console.keyMap = "uk";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    smartmontools
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.11";
}
