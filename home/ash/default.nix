{ config, pkgs, ... }: {
  home.stateVersion = "22.11";

  programs.fish.enable = true;
  programs.fsh.enable = true;
#  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    wget
    cachix
  ];
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      keys.normal."`" = "switch_to_lowercase";
      keys.normal."C-`" = "switch_to_uppercase";
    };
  };
}
