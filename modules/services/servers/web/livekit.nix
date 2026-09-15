{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.services.livekit;
in

{
  options.forest.services.livekit = {
    enable = lib.mkEnableOption "livekit";
    keyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Age file the keys are loaded from.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."livekit-keys".file = cfg.keyFile;

    services.livekit = {
      enable = true;
      settings = { };
      keyFile = config.age.secrets."livekit-keys".path;
    };

    # We do it manually as we don't want to open the main TCP port
    networking.firewall.allowedUDPPortRanges = [
      {
        from = config.services.livekit.settings.rtc.port_range_start;
        to = config.services.livekit.settings.rtc.port_range_end;
      }
    ];
  };
}
