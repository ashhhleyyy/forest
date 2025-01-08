{ pkgs, ... }: {
  services.soju = {
    enable = true;
    # listen only over tailscale
    listen = ["irc+insecure://100.97.123.128"];
    adminSocket.enable = true;
  };
}
