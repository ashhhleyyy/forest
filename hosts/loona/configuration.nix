{ config, modulesPath, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    ../../common/generic-uefi-zfs.nix
    ../../common/tailscale.nix
    ../../common/tpm.nix
    ../../roles/libvirt.nix
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
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
    };
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
  hardware.usb-modeswitch.enable = true;

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
    })
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];

  virtualisation.waydroid.enable = true;

  system.stateVersion = "22.11";
}
