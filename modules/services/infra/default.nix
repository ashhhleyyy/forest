{ ... }: {
  imports = [
    ./backups.nix
    ./docker-registry.nix
    ./kube.nix
    ./munin.nix
    ./pg-vacuum.nix
    ./postgres.nix
    ./prometheus.nix
    ./tailscale.nix
  ];
}
