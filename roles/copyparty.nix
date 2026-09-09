{ pkgs, config, ... }: {
  age.secrets.copyparty-ash = {
    file = ../secrets/copyparty-ash.age;
    owner = "copyparty";
    group = "copyparty";
  };
  age.secrets.rclone-copyparty.file = ../secrets/rclone-copyparty.age;

  environment.systemPackages = [ pkgs.rclone ];

  fileSystems."/mnt/copyparty" = {
    device = "copyparty:/";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=${config.age.secrets.rclone-copyparty.path}"
    ];
  };

  services.copyparty = {
    enable = true;
    settings = {
      i = "::";
      p = [ 3009 ];
    };
    accounts = {
      ash.passwordFile = config.age.secrets.copyparty-ash.path;
    };
    volumes = {
      "/" = {
        path = "/mnt/copyparty";
        access = {
          r = "*";
          rw = ["ash"];
        };
        flags = {
          e2d = true;
          e2dsa = true;
          e2t = true;
          e2ts = true;
        };
      };
      "/priv" = {
        path = "/mnt/copyparty/priv";
        access = {
          r = [];
          rw = ["ash"];
        };
        flags = {
          e2d = true;
          e2dsa = true;
          e2t = true;
          e2ts = true;
        };
      };
    };
  };
}
