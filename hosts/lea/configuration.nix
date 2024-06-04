{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/cachix.nix
      ../../common/generic.nix
      ../../common/server.nix
      ../../common/tailscale.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;

  services.smartd.enable = true;
  
  networking.hostName = "lea";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  console.keyMap = "uk";

  nix.settings.trusted-users = [ "@wheel" ];

  users.users.ash.extraGroups = [ "networkmanager" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    helix
    smartmontools
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.11";
}
