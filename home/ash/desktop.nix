{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    firefox
    fluffychat
    cachix
    prismlauncher
    gnome.gnome-sudoku
  ];

  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
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
  };

  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
