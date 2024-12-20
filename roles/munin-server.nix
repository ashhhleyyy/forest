{ pkgs, config, ... }: {
  services.munin-cron = {
    enable = true;
    hosts = ''
      [${config.networking.hostName}]
      address localhost

      [amy]
      address amy.ash.ley
    '';
  };

  services.caddy.virtualHosts."munin.service.isnt-a.top".extraConfig = ''
    log {
      output file /var/log/caddy/munin.service.isnt-a.top-access.log
    }

    root * /var/www/munin
    file_server
  '';
}
