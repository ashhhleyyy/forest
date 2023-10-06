{ config, pkgs, ... }: {
  services.flatpak.enable = true;

  home.packages = with pkgs; [
    nerdfonts
    firefox
    fluffychat
    cachix
    prismlauncher
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
}
