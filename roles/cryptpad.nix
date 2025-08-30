{ ... }: {
  services.cryptpad = {
    enable = true;
    settings = {
      httpSafeOrigin = "https://cryptpad-sandbox.ashhhleyyy.dev";
      httpUnsafeOrigin = "https://cryptpad.ashhhleyyy.dev";
      blockDailyCheck = true;
      httpPort = 3002;
      websocketPort = 3003;
      httpAddress = "0.0.0.0"; # this is fine because firewall lol
      adminKeys = [
        "[ash@cryptpad.ashhhleyyy.dev/ShpVAzqTPFZuqGhyhqpjBc3fUr4GBhUcaJEUmZqPzOg=]"
      ];
    };
  };

  forest.backups.paths = [ "/var/lib/private/cryptpad" ];
}
