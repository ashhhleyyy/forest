{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.itwont-work;
  app = "itwont-work";
  domain = "itwont.work";
  appDir = "/var/www/${domain}";
in

{
  options.forest.services.itwont-work = {
    enable = lib.mkEnableOption "itwont-work";
  };

  config = lib.mkIf cfg.enable {
    users.users.nico = {
      description = "Nico";
      isNormalUser = true;
      shell = pkgs.bash;
      packages = with pkgs; [
        php85
        php85Packages.composer
      ];
      extraGroups = [
        "itwont-work"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIES6FqJ23JNJcHTfKMPSbdPYcRcMecZWWNKyHLUbVXfB nico@itwont.work"
      ];
    };

    security.doas.extraRules = [{
      users = ["nico"];
      runAs = app;
      noPass = true;
    }];

    users.users.${app} = {
      isSystemUser = true;
      createHome = true;
      homeMode = "755";
      home = appDir;
      group = app;
    };
    users.groups.${app} = {};

    services.caddy.virtualHosts."itwont.work".extraConfig = ''
      @not-assets {
        not path *.css *.png *.xml
      }
      import blockbots
      encode zstd gzip
      root * ${appDir}
      header * X-Frame-Options SAMEORIGIN
      header * X-XXS-Protection "1; mode=block"
      header * X-Content-Type-Options nosniff
      rewrite @not-assets /index.html
      file_server {
        status 404
      }
    '';

    forest.backups.paths = [ appDir ];
  };
}
