{ config, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ./hardware-config.nix
  ];

  networking.hostName = "alex";
  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "gb";
    # xkbVariant = "";
  };

  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11";
}
