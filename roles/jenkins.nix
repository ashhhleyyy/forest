{ config, pkgs, ... }: {
  services.jenkins = {
    enable = true;
    listenAddress = "localhost";

    packages = [ pkgs.stdenv pkgs.git pkgs.jdk17 pkgs.bash config.programs.ssh.package pkgs.nix ];
  };

  services.caddy.virtualHosts."jenkins.service.isnt-a.top".extraConfig = ''
    log {
      output file /var/log/caddy/jenkins.service.isnt-a.top-access.log
    }

    reverse_proxy localhost:8080
  '';
}
