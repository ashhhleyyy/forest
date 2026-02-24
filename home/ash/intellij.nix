{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.rider
    android-studio
  ];
}
