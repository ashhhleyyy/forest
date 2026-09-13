{ ... }: {
  imports = [
    ./backups.nix
    ./docker-registry.nix
    ./kube.nix
    ./munin.nix
    ./pg-vacuum.nix
    ./prometheus.nix
    ./tailscale.nix
  ];
}
