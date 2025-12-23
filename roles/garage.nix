{ config, pkgs, ... }:

{
  services.garage = {
    enable = true;
    package = pkgs.garage_2;
  };

  forest.backups.paths = [ "/var/lib/garage" ];
}
