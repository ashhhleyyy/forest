{ config, modulesPath, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi-zfs.nix
    ../../common/tpm.nix
    ../../roles/podman.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "loona";
  networking.hostId = "df9469a3";
  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  security.pam.services = {
    kde.u2fAuth = true;
    sddm.u2fAuth = true;
    doas.u2fAuth = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "gb";
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.rtl-sdr.enable = true;
  users.users.ash.extraGroups = ["plugdev"];

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;

  virtualisation.waydroid.enable = true;

  system.stateVersion = "22.11";
}
