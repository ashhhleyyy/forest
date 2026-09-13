{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.forest.services.munin;
in

{
  options.forest.services.munin = {
    enable = lib.mkEnableOption "munin-node";
    server = {
      enable = lib.mkEnableOption "munin-server";
      nodes = lib.mkOption {
        description = "Map of node name -> address";
        type = lib.types.attrsOf lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.munin-node = {
      enable = true;
      extraConfig = ''
      cidr_allow 100.64.0.0/10
      cidr_allow fd7a:115c:a1e0::/48
      '';
    };

    services.munin-cron = lib.mkIf cfg.server.enable {
      enable = true;
      hosts = ''
        [${config.networking.hostName}]
        address localhost

        ${lib.join "\n" (map ({ name, value }: ''
          [${name}]
          address ${value}
        '') (lib.attrsets.attrsToList cfg.server.nodes))}
      '';
    };

    services.caddy.virtualHosts.":3004".extraConfig = lib.mkIf cfg.server.enable ''
      root * /var/www/munin
      file_server
    '';
  };
}
