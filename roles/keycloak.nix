{ config, lib, pkgs, ... }: {
  age.secrets.keycloakPostgres.file = ../secrets/keycloakPostgres.age;

  services.keycloak = {
    enable = true;
    themes = {
      shorks = pkgs.fetchgit {
        rev = "e6c1edaf61d39227b765b873aaef126691b51d2d";
        url = "https://git.ashhhleyyy.dev/shorks-gay/shorks-keycloak.git";
        hash = "sha256-M5PHrqN+OneWMklr4TDg2qeX0f1b8puNVduofsr24EA=";
      };
    };
    plugins = [
      ((pkgs.fetchMavenArtifact {
        groupId = "gay.shorks";
        artifactId = "icecloak";
        version = "1.0.0+kc.24";
        repos = ["https://maven.ashhhleyyy.dev/releases/"];
        hash = "sha256-xlyq1f12HFgVLe+RPJeo0pxIBculWgu4zODEzlRErB0=";
      }).passthru.jar)
    ];
    settings = {
      hostname = "account.shorks.gay";
      http-port = 8008;
      http-enabled = true;
      proxy-headers = "xforwarded";
    };
    database.passwordFile = config.age.secrets.keycloakPostgres.path;
  };
}
