{ config, pkgs, ... }: {
  imports = [
    ../../roles/asterisk.nix
    ../../roles/coredns
  ];

  networking = {
    hostName = "emira";
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  networking.firewall.enable = false;

  forest.boot.qemu.enable = true;

  system.stateVersion = "22.11";
}
