{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.phpstorm
    jetbrains.rider
    jetbrains.pycharm
    android-studio
    jetbrains-toolbox
  ];
}
