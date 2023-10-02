{ config, pkgs, ... }: {
  imports = [
    ../../common/generic.nix
    ../../roles/asterisk.nix
    ../../roles/kanidm.nix
    ../../roles/coredns
  ];

  networking = {
    hostName = "emira";
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  networking.firewall.enable = false;

  system.stateVersion = "22.11";
}
