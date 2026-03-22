{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi-zfs.nix
    ../../common/tailscale.nix
    ../../common/tpm.nix
    ../../roles/libvirt.nix
    ../../roles/obs.nix
    ../../roles/podman.nix
  ];

  networking.hostName = "fern";
  networking.hostId = "e905d5d3";
  networking.firewall.enable = false;

  hardware.bluetooth.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "gb";
      videoDrivers = ["nvidia"];
    };
    displayManager.plasma-login-manager = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      #intel-media-sdk
    ];
  };

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
  };

  services.printing.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.sane.enable = true;

  hardware.rtl-sdr.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.zoom-us.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.clementine.ipod = true;

  system.stateVersion = "26.05";

  #nixpkgs.config.permittedInsecurePackages = [
  #  "intel-media-sdk-23.2.2"
  #];
}
