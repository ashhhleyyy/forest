{ pkgs, ... }: {
  services.iocaine = {
    enable = true;
    config = {
      server.default = {
        bind = "127.0.0.1:42069";
        mode = "http";
        use.handler-from = "default";
        use.metrics = "metrics";
      };
      server.metrics = {
        bind = "0.0.0.0:42042";
        mode = "prometheus";
        persist-path = "qmk-metrics.json";
        persist-interval = "1h";
      };
      handler.default = {
        config = {
          ai-robots-txt-path = pkgs.fetchurl {
            url = "https://github.com/ai-robots-txt/ai.robots.txt/raw/2f5d7ccf39b2f95e5163c6debbe7aebfb77edb11/robots.json";
            hash = "";
          };
          sources = {
            training-corpus = [
              (pkgs.callPackage ./1984.nix)
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
}
