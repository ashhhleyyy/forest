{ config, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "shorks-gay" ];
    enableTCPIP = true;
    dataDir = "/data/postgresql/${config.services.postgresql.package.psqlSchema}";
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
      host  all      all     100.64.0.0/10  trust
      # ipv6
      host all       all     ::1/128        trust
    '';
  };
}
