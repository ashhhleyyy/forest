{
  config,
  lib,
  pkgs,
  ...
}:

let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGLHqRBcN584SXXa7snrOs89Wy5Jjvsq+GlFXTTBYfp ash@ash-pc"
    "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBKx0GvYviMXBGtGN/V3t0uPkT6tmpQhtGbd1GzDoNe75K9ZorsrZaBbJBjg39yCVMkWnWjWYGd7R7GcV3fKeLGoAAAAEc3NoOg== ash@fern"
    "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGnb4PwF+hL21JY0ytFpkk/WaYM19Xv9efYQGdeba5a2RcElFKoEtklU4SUh+uhwaOz4TP3lWJUMEnfDDpFnmlwAAAAEc3NoOg== ash@alex"
  ];
in

{
  options.forest.common.deploy-user = {
    enable = lib.mkEnableOption "deploy-user";
  };

  config = {
    users.users.ash = {
      description = "Ashley";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = authorizedKeys;
      hashedPassword = "$y$j9T$vEWmND1vcYNJh5nGbF7ER/$UIi8pHNUvVAkgpnhA/XDTt6VeDFxIQmGMiOWA4gCj6/";
      extraGroups = [
        "wheel"
        "audio"
        "dialout"
      ];
    };

    users.groups.deploy = lib.mkIf config.forest.common.deploy-user.enable { };
    users.users.deploy = lib.mkIf config.forest.common.deploy-user.enable {
      description = "Deploy";
      group = "deploy";
      isNormalUser = false;
      isSystemUser = true;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOfH436QTUDSNGd254ADoyBKNRL4Y+abCeWXLt5liW3 deploy@ashhhleyyy.dev"
      ];
    };
    security.sudo.extraRules = lib.mkIf config.forest.common.deploy-user.enable [
      {
        users = [ "deploy" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    security.doas.enable = true;
    security.doas.wheelNeedsPassword = false;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    users.mutableUsers = false;
  };
}
