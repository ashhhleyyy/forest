{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    jetbrains.rider
    jetbrains.pycharm-professional
    android-studio
    jetbrains-toolbox
  ];
}
