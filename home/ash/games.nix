{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    # celeste mod manager
    olympus
  ];
}
