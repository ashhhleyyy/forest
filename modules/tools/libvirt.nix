{ config, lib, pkgs, ... }:

let
  cfg = config.forest.tools.libvirt;
in

{
  options.forest.tools.libvirt = {
    enable = lib.mkEnableOption "libvirt";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    users.users.ash.extraGroups = ["libvirtd"];
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
