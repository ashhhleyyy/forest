{ config, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    settings = {
      max_connections = 200;
      shared_buffers = "768MB";
      effective_cache_size = "2304MB";
      maintenance_work_mem = "192MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 4;
      effective_io_concurrency = 2;
      work_mem = "1966kB";
      huge_pages = false;
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 4;
      max_parallel_workers_per_gather = 2;
      max_parallel_workers = 4;
      max_parallel_maintenance_workers = 2;
    };
    ensureDatabases = [ "shorks-gay" ];
    enableTCPIP = true;
    dataDir = pkgs.lib.mkIf (config.networking.hostName == "lea") "/data/postgresql/${config.services.postgresql.package.psqlSchema}";
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

  services.pg-vacuum = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };

  services.postgresqlBackup = {
    enable = true;
    # databases = ["shorks-gay"];
    startAt = "*-*-* 03:00:00";
  };

  forest.backups.paths = ["/var/backups/postgresql"];
}
