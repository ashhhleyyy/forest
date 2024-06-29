{ pkgs, ... }: {
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "shorks.gay";
        database_backend = "rocksdb";
        allow_check_for_updates = true;
        address = "::";
      };
    };
  };
}
