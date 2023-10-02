{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    firefox
  ];

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };
}
