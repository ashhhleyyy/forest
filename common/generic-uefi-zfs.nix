{ pkgs, ... }: {
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    theme = "${pkgs.catppuccin.override { variant = "latte"; accent = "mauve"; }}/grub";
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };
}
