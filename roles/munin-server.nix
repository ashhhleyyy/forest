{ pkgs, config, ... }: {
  services.munin-cron = {
    enable = true;
    hosts = ''
      [${config.networking.hostName}]
      address localhost

      [amy]
      address amy.bun-galaxy.ts.net
    '';
  };

  services.caddy.virtualHosts.":3004".extraConfig = ''
    root * /var/www/munin
    file_server
  '';
}
