{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    emacs30
    ripgrep
  ];
}
