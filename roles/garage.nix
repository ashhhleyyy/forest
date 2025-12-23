{ config, pkgs, ... }:

{
  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    settings = {};
  };

  forest.backups.paths = [ "/var/lib/garage" ];
}
