{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en-gb-large
    fluffychat

    krita
    clementine
    spotify
  ];

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        device_name = config.networking.hostName;
        device_type = "computer";
        use_mpris = true;
        dbus_type = "session";
        backend = "pulseaudio";
      };
    };
  };
}
