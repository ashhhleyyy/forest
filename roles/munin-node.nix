{ pkgs, ... }: {
  services.munin-node = {
    enable = true;
    extraConfig = ''
    cidr_allow 100.64.0.0/10
    cidr_allow fd7a:115c:a1e0::/48
    '';
  };
}
