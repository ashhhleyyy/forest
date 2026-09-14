{
  max_connections = 200;
  shared_buffers = "768MB";
  effective_cache_size = "2304MB";
  maintenance_work_mem = "192MB";
  checkpoint_completion_target = 0.9;
  wal_buffers = "16MB";
  default_statistics_target = 100;
  random_page_cost = 1.1;
  effective_io_concurrency = 200;
  work_mem = "4MB";
  huge_pages = false;
  jit = false;
  wal_compression = "lz4";
  io_method = "io_uring";
  min_wal_size = "1GB";
  max_wal_size = "4GB";
  max_worker_processes = 4;
  max_parallel_workers_per_gather = 2;
  max_parallel_workers = 4;
  max_parallel_maintenance_workers = 2;
}
