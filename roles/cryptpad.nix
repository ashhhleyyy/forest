{ ... }: {
  services.cryptpad = {
    enable = true;
    settings = {
      httpSafeOrigin = "https://cryptpad-sandbox.ashhhleyyy.dev";
      httpUnsafeOrigin = "https://cryptpad.ashhhleyyy.dev";
      blockDailyCheck = true;
      httpPort = 3002;
      websocketPort = 3003;
    };
  };
}
