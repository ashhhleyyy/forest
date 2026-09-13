{ config, lib, pkgs, ... }:

let
  cfg = config.forest.boot.systemd-boot;
in

{
  options.forest.boot.systemd-boot = {
    enable = lib.mkEnableOption "systemd-boot";
  };
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
  };
}
