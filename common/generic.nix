{ pkgs, ... }: rec {
  imports = [
    ./cachix.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    };
  };

  users.users.ash = {
    description = "Ashley";
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGLHqRBcN584SXXa7snrOs89Wy5Jjvsq+GlFXTTBYfp ash@ash-pc"
    ];
    hashedPassword = "$y$j9T$YZw49GYsZi6pm5MH3W2gX1$BKPBL3g4jAWUJP0WY0lRrBLorxzcENVqGTG0dAly3v7";
    extraGroups = [ "wheel" "audio" ];
  };

  security.doas.enable = true;
  security.doas.wheelNeedsPassword = false;

  users.users.root.openssh.authorizedKeys.keys = users.users.ash.openssh.authorizedKeys.keys;

  users.mutableUsers = false;

  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [
    git
    helix
  ];
}
