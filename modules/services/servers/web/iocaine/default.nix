{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.iocaine;
in

{
  options.forest.services.iocaine = {
    enable = lib.mkEnableOption "iocaine";
  };

  config = lib.mkIf cfg.enable {
    services.maxmind-db-update = {
      enable = true;
      attachTo = "iocaine";
    };

    services.iocaine = {
      enable = true;
      config = {
        server.default = {
          bind = "127.0.0.1:42069";
          mode = "http";
          use.handler-from = "nsoe";
          use.metrics = "metrics";
        };
        server.metrics = {
          bind = "0.0.0.0:42042";
          mode = "prometheus";
          persist-path = "qmk-metrics.json";
          persist-interval = "1h";
        };
        handler.nsoe = {
          path = "${pkgs.nam-shub-of-enki}";
          config = {
            inherits = "default";

            ai-robots-txt-path = pkgs.fetchurl {
              url = "https://github.com/ai-robots-txt/ai.robots.txt/raw/425d1a6207992e5ead73e2dd71fd98283dc7d9b6/robots.json";
              hash = "";
            };
            checks.asn.database-path = "GeoLite2-ASN.mmdb";

            sources = {
              training-corpus = [
                "${pkgs.callPackage ./1984.nix { }}"
                # TODO: more input material
              ];
              wordlists = [
                "${pkgs.miscfiles}/share/web2"
              ];
            };
          };
        };
      };
    };
  };
}
