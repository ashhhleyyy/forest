{ ... }: {
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users.ash.extraGroups = [ "tss" ];
  users.groups.uhid = {
    members = [ "ash" ];
  };
  services.udev.extraRules = ''
  KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="uhid", MODE="0660"
  '';
}
