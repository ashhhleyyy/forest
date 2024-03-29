{ config, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi.nix
    ../../common/tailscale.nix
    ../../common/tpm.nix
    ../../roles/kodi.nix
    ../../roles/podman.nix
    ./hardware-config.nix
  ];

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/00f32b39-dfcb-4459-bf8e-aa68e2198466";
    preLVM = true;
    allowDiscards = true;
  };

  networking.hostName = "alex";
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

  services.xserver = {
    enable = true;
#    displayManager.gdm.enable = true;
#    desktopManager.gnome.enable = true;
    
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    xkb.layout = "gb";
    # xkbVariant = "";
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

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  #programs.calls.enable = true;

  virtualisation.waydroid.enable = true;

  system.stateVersion = "22.11";
}
