{ config, pkgs, ... }: {
  home.stateVersion = "22.11";

  programs.fish.enable = true;
  programs.fsh.enable = true;
  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    wget
    cachix
  ];
}
