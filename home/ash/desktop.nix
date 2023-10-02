{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    firefox
    fluffychat
  ];

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };
}
