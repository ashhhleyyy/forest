{ ... }: {
  imports = [
    ./backups.nix
    ./kube.nix
    ./munin.nix
    ./pg-vacuum.nix
    ./tailscale.nix
  ];
}
