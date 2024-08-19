{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 25565 ];
  users.users.proxy = {
    isNormalUser = false;
    isSystemUser = true;
    home = "/tmp";
    description = "proxy";
    group = "proxy";
  };
  users.groups.proxy = {};
}
