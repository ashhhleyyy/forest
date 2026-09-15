{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.forest.programs.obs;
in

{
  options.forest.programs.obs = {
    enable = lib.mkEnableOption "obs";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
      enableVirtualCamera = true;
    };
  };
}
