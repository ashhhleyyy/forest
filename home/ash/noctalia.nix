{ ... }: {
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "light";
        source = "builtin";
        builtin = "Catppuccin";
      };
      shell = {
        launch_apps_as_systemd_services = true;
      };
    };
    systemd.enable = true;
  };
}
