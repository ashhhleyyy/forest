{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
#    fluffychat
    cachix
    prismlauncher
    gnome-sudoku
    dino
    thunderbird
    vlc
    unrar # for ark
#    zed-editor
  ];

  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };

  programs.git = {
    enable = true;
    userName = "Ashhhleyyy";
    userEmail = "ash@ashhhleyyy.dev";
    signing = {
      key = "83B789081A0878FB";
      signByDefault = true;
    };
    lfs.enable = true;
  };

  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentryPackage = pkgs.pinentry-qt;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  services.ssh-agent.enable = true;
  programs.ssh.forwardAgent = true;
}
