{ pkgs, ... }: {
  services.jenkins = {
    enable = true;
    listenAddress = "localhost";
  };

  services.caddy.virtualHosts."jenkins.service.isnt-a.top".extraConfig = ''
    log {
      output file /var/log/caddy/jenkins.service.isnt-a.top-access.log
    }

    reverse_proxy localhost:8080
  '';
}
