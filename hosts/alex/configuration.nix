{ config, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi.nix
    ../../common/tailscale.nix
    ../../common/tpm.nix
    ../../roles/kodi.nix
    ../../roles/libvirt.nix
    ../../roles/niri.nix
    ../../roles/podman.nix
    ./hardware-config.nix
  ];

  boot.initrd.luks = {
    devices.root = {
      device = "/dev/disk/by-uuid/00f32b39-dfcb-4459-bf8e-aa68e2198466";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "alex";
  networking.firewall.enable = false;

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
  };

  #environment.systemPackages = with pkgs; [
  #  gnomeExtensions.appindicator
  #  gnomeExtensions.mpris-label
  #  gnome.gnome-tweaks
  #];
  #services.udev.packages = with pkgs; [
  #  gnome.gnome-settings-daemon
  #];

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
    ];
  };

  services.gpsd = {
    enable = true;
    devices = [
      "/dev/ttyACM0"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.rtl-sdr.enable = true;
  users.users.ash.extraGroups = ["plugdev"];

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  #programs.calls.enable = true;

  virtualisation.waydroid.enable = true;

  services.logind.lidSwitch = "ignore";

  system.stateVersion = "22.11";
}
