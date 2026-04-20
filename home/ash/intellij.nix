{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.rider
    jetbrains.clion
    android-studio
  ];
}
