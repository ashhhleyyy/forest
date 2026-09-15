{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.profiles.server;
in

{
  options.forest.profiles.server = {
    enable = lib.mkEnableOption "server profile";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty.terminfo
      goaccess
    ];
  };
}
