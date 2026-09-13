{ ... }: {
  imports = [
    ./grub.nix
    ./qemu.nix
    ./systemd-boot.nix
  ];
}
