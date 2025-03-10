{ config, pkgs, ... }: {
  imports = [
    ../../common/generic-qemu.nix
    ../../common/generic.nix
    ../../common/generic-desktop.nix
  ];

  networking.hostName = "fern";
  networking.firewall.enable = false;

  sound.enable = true;
  services.pulseaudio.enable = false;
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
    # layout = "gb";
    # xkbVariant = "";
  };

  services.printing.enable = true;

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11";
}
