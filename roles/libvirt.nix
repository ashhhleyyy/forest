{ pkgs, ... }: {
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
}
