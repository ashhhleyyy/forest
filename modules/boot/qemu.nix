{ modulesPath, lib, config, ... }:

let
  cfg = config.forest.boot.qemu;
in

{
  options.forest.boot.qemu = {
    enable = lib.mkEnableOption "qemu";
  };

  config = lib.mkIf cfg.enable {
    forest.boot.grub.enable = true;

    # track https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/qemu-guest.nix
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "sr_mod"
      "uhci_hcd"

      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
      "virtiofs"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    boot.kernelParams = [
      "console=tty1"
      "console=ttyS0,115200"
    ];

    fileSystems."/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };
  };
}
