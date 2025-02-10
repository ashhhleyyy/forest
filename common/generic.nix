{ pkgs, ... }: rec {
  imports = [
    ./cachix.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" "deploy" ];

  boot.tmp.cleanOnBoot = true;
  boot.supportedFilesystems = [ "ntfs" ];
  nix.settings.auto-optimise-store = true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  programs.fish.enable = true;
  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      "screen:Main" = "PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME IO_RATE Command";
      column_meters_1 = "Tasks LoadAverage Uptime DiskIO NetworkIO Systemd";
    };
  };

  users.users.ash = {
    description = "Ashley";
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGLHqRBcN584SXXa7snrOs89Wy5Jjvsq+GlFXTTBYfp ash@ash-pc"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBKx0GvYviMXBGtGN/V3t0uPkT6tmpQhtGbd1GzDoNe75K9ZorsrZaBbJBjg39yCVMkWnWjWYGd7R7GcV3fKeLGoAAAAEc3NoOg== ash@fern"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGnb4PwF+hL21JY0ytFpkk/WaYM19Xv9efYQGdeba5a2RcElFKoEtklU4SUh+uhwaOz4TP3lWJUMEnfDDpFnmlwAAAAEc3NoOg== ash@alex"
    ];
    hashedPassword = "$y$j9T$vEWmND1vcYNJh5nGbF7ER/$UIi8pHNUvVAkgpnhA/XDTt6VeDFxIQmGMiOWA4gCj6/";
    extraGroups = [ "wheel" "audio" "dialout" "adbusers" ];
  };

  users.groups.deploy = {};
  users.users.deploy = {
    description = "Deploy";
    group = "deploy";
    isNormalUser = false;
    isSystemUser = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOfH436QTUDSNGd254ADoyBKNRL4Y+abCeWXLt5liW3 deploy@ashhhleyyy.dev"
    ];
  };
  security.sudo.extraRules = [
    { users = [ "deploy" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  security.doas.enable = true;
  security.doas.wheelNeedsPassword = false;

  users.users.root.openssh.authorizedKeys.keys = users.users.ash.openssh.authorizedKeys.keys;

  users.mutableUsers = false;

  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [
    git
    helix
    lsof
    tmux
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  services.prometheus.exporters = {
    systemd.enable = true;
    node.enable = true;
  };
}
