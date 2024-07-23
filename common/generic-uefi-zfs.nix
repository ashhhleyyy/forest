{ pkgs, ... }: {
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    theme = "${pkgs.catppuccin.override { variant = "mocha"; accent = "mauve"; }}/grub";
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };
}
