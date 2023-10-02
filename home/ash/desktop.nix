{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    firefox
    fluffychat
    git
  ];

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };
}
