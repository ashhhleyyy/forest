{
  config
, pkgs
, ...
}:

{
  services.youtrack = {
    enable = true;
    environmentalParameters.listen-port = 3002;
    package = pkgs.youtrack;
  };

  services.caddy.virtualHosts."yt.isnt-a.top".extraConfig = ''
    encode zstd gzip
    reverse_proxy 127.0.0.1:3002
  '';

  forest.backups.paths = [ "/var/lib/youtrack" ];
}
