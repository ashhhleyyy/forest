{ config, pkgs, ... }: rec {
  services.coredns = {
    enable = true;
    config = ''
    ley {
      bind 0.0.0.0
      file ${pkgs.writeText "ash.ley" (builtins.readFile ./ash.ley)}
      prometheus 0.0.0.0:9153
    }

    . {
      bind 0.0.0.0
      forward . tls://1.1.1.1 tls://1.0.0.1
      prometheus 0.0.0.0:9153
    }
    '';
  };
}
