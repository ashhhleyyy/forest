{ config, pkgs, ... }: {
  services.jenkins = {
    enable = true;
    listenAddress = "0.0.0.0";

    packages = [ pkgs.stdenv pkgs.git pkgs.jdk17 pkgs.bash config.programs.ssh.package pkgs.nix ];
  };

  services.caddy.virtualHosts."jenkins.service.isnt-a.top".extraConfig = ''
    reverse_proxy localhost:8080
  '';
}
