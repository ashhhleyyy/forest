{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.uptime-kuma;
in

{
  options.forest.services.uptime-kuma = {
    enable = lib.mkEnableOption "uptime-kuma";
  };

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        HOST = "0.0.0.0";
        PORT = "4000";
      };
    };
  };
}
