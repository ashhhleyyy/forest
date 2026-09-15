{ config, pkgs, ... }: {
  imports = [
    ../../roles/niri.nix
    ./hardware-config.nix
  ];

  boot.initrd.luks = {
    devices.root = {
      device = "/dev/disk/by-uuid/00f32b39-dfcb-4459-bf8e-aa68e2198466";
      preLVM = true;
      allowDiscards = true;
    };
  };
  forest = {
    common.boot.systemd-boot.enable = true;
    profiles.desktop = {
      enable = true;
      tpm.enable = true;
    };
    services.tailscale.enable = true;
    tools = {
      libvirt.enable = true;
      podman.enable = true;
    };
  };

  networking.hostName = "alex";
  networking.firewall.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
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
  users.users.ash.extraGroups = [ "plugdev" ];

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  #programs.calls.enable = true;

  virtualisation.waydroid.enable = true;

  services.logind.lidSwitch = "ignore";

  system.stateVersion = "22.11";
}
