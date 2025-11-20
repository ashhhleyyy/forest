{ config, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    settings = {
      max_connections = 200;
      shared_buffers = "1GB";
      effective_cache_size = "3GB";
      maintenance_work_mem = "256MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "5041kB";
      huge_pages = false;
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser  auth-method
      local all      all     peer
      #type database DBuser  origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   scram-sha-256
      host  all      all     100.64.0.0/10  scram-sha-256
      host  all      all     0.0.0.0/0     scram-sha-256
      # ipv6
      host all       all     ::1/128        scram-sha-256
    '';
  };

  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 03:00:00";
  };

  forest.backups.paths = ["/var/backup/postgresql"];
}
