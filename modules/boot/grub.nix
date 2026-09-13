{ pkgs, lib, config, ... }:

let
  cfg = config.forest.boot.grub;
in

{
  options.forest.boot.grub = {
    enable = lib.mkEnableOption "grub";
    zfs.enable = lib.mkEnableOption "grub zfs";
    uefi.enable = lib.mkEnableOption "grub uefi";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      theme = "${pkgs.catppuccin.override { variant = "latte"; accent = "mauve"; }}/grub";
      device = lib.mkIf (!cfg.uefi.enable) "/dev/sda";
      useOSProber = lib.mkIf (!cfg.uefi.enable) true;
      efiSupport = lib.mkIf cfg.uefi.enable true;
      efiInstallAsRemovable = lib.mkIf cfg.uefi.enable true;
      zfsSupport = lib.mkIf cfg.zfs.enable true;
      mirroredBoots = lib.mkIf cfg.zfs.enable [
        { devices = [ "nodev"]; path = "/boot"; }
      ];
    };
    boot.zfs.forceImportRoot = lib.mkIf cfg.zfs.enable false;
  };
}
