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

  services.caddy.virtualHosts."http://munin.service.isnt-a.top:3004".extraConfig = ''
    root * /var/www/munin
    file_server
  '';
}
