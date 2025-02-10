{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    android-studio
    jetbrains-toolbox
  ];
}
