{ pkgs, config, ... }: {
  age.secrets.grafana-secret-key = {
    file = ../secrets/grafana-secret-key.age;
    owner = "grafana";
    group = "grafana";
  };

  services.gerrit = {
    enable = true;
    builtinPlugins = [
      "delete-project"
      "webhooks"
    ];
    serverId = "713db6da-21ff-4fa6-9414-32939b2892b3";
    listenAddress = "[::]:3009";
  };

  forest.backups.paths = [ "/var/lib/grafana" ];
}
