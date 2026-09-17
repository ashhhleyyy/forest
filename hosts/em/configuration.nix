{
  config,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    ../../common/generic.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  forest.profiles.desktop.enable = true;

  networking.hostName = "em";
  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
