{ pkgs, ... }: {
  services.journald.settings.Journal = {
    SystemMaxUse = "100M";
    MaxFileSec = "7day";
  };
}
