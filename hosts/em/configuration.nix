{ config, modulesPath, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../common/generic-desktop.nix
    (modulesPath + "/profiles/qemu-guest.nix")

    ../../roles/niri.nix
  ];

  networking.hostName = "em";
  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
