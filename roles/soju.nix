{ pkgs, ... }: {
  services.soju = {
    enable = true;
    # listen only over tailscale
    listen = ["irc+insecure://100.97.123.128"];
    adminSocket.enable = true;
    # we store in the db
    enableMessageLogging = false;
    extraConfig = ''
      message-store db
    '';
  };

  environment.systemPackages = with pkgs; [
    soju
  ];
}
