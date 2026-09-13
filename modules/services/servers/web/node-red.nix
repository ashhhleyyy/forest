{ config, lib, pkgs, ... }:

let
  cfg = config.forest.services.node-red;
in

{
  options.forest.services.node-red = {
    enable = lib.mkEnableOption "node-red";
  };

  config = lib.mkIf cfg.enable {
    services.node-red = {
      enable = true;
      withNpmAndGcc = true;
    };
  };
}
