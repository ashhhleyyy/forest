{ config, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi.nix
    ../../common/tailscale.nix
    ../../common/tpm.nix
    ../../roles/podman.nix
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

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
    ];
  };

  hardware.bluetooth.enable = true;

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.calls.enable = true;

  system.stateVersion = "22.11";
}
