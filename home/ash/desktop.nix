{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    firefox
    fluffychat
    fractal-next
  ];

  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };
}
