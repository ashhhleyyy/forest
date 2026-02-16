{ config, pkgs, lib, ... }:

let
  app = "itwont-work";
  domain = "itwont.work";
  appDir = "/var/www/${domain}";
in

{
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

  services.phpfpm.pools.${app} = {
    user = app;
    settings = {
      "listen.owner" = config.services.caddy.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php85 ];
    phpOptions = ''
    upload_max_filesize = 128M
    post_max_size = 128M
    '';
  };
  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    homeMode = "755";
    home = appDir;
    group = app;
  };
  users.groups.${app} = {};

  services.caddy.virtualHosts."itwont.work".extraConfig = ''
    import blockbots
    encode zstd gzip
    root * ${appDir}/public
    header * X-Frame-Options SAMEORIGIN
    header * X-XXS-Protection "1; mode=block"
    header * X-Content-Type-Options nosniff
    php_fastcgi unix/${config.services.phpfpm.pools.${app}.socket}
    file_server
  '';

  forest.backups.paths = [ appDir ];
}
