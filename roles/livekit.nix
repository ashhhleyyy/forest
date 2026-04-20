{ pkgs, config, ... }: {  
  age.secrets."livekit-keys".file = ../secrets/livekit-keys.age;

  services.livekit = {
    enable = true;
    settings = {};
    keyFile = config.age.secrets."livekit-keys".path;
  };

  # We do it manually as we don't want to open the main TCP port
  networking.firewall.allowedUDPPortRanges = [
    {
      from = config.services.livekit.settings.rtc.port_range_start;
      to = config.services.livekit.settings.rtc.port_range_end;
    }
  ];
}
