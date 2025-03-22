{ config, ... }: {
  age.secrets.mumble-server.file = ../secrets/mumble-server.age;

  services.murmur = {
    enable = true;
    openFirewall = true;
    password = "$MURMURD_PASSWORD";
    welcometext = "lol";
    environmentFile = config.age.secrets.mumble-server.path;
  };
}
