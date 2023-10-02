{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
  ];

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };
}
