{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./cachix.nix
    ./locale.nix
    ./users.nix
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "@wheel"
    "deploy"
  ];

  boot.tmp.cleanOnBoot = true;
  nix.settings.auto-optimise-store = true;

  programs.fish.enable = true;
  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      "screen:Main" =
        "PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME IO_RATE Command";
      column_meters_1 = "Tasks LoadAverage Uptime DiskIO NetworkIO Systemd";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    helix
    lsof
    tmux
    ripgrep
    bat
    wget
    file
  ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-25.9.0"
  # ];

  services.prometheus.exporters = {
    systemd.enable = true;
    node.enable = true;
  };

  services.journald =
    if (config.system.nixos.release == "26.05") then
      {
        extraConfig = ''
          SystemMaxUse=100M
          MaxFileSec=7day
        '';
      }
    else
      {
        settings.Journal = {
          SystemMaxUse = "100M";
          MaxFileSec = "7day";
        };
      };
}
