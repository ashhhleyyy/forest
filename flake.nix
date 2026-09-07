{
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fsh = {
      url = "github:ashhhleyyy/fsh";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    aci = {
      url = "github:ashhhleyyy/aci";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix.url = "github:ryantm/agenix";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    binary-ninja = {
      url = "github:ashhhleyyy/nix-binary-ninja/update/6.0.10601";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixocaine = {
      url = "https://git.madhouse-project.org/iocaine/nixocaine/archive/stable.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nam-shub-of-enki.url = "git+https://git.madhouse-project.org/iocaine/nam-shub-of-enki?ref=iocaine-3.x";
    };
  };

  outputs = {
    self,
    nixpkgs-stable, nixpkgs-unstable,
    home-manager-stable, home-manager-unstable,
    nixos-generators,
    fsh,
    aci,
    vscode-extensions,
    agenix,
    niri-flake,
    flake-utils,
    binary-ninja,
    nixocaine,
    ...
  }:
  let
    home-manager = home-manager-unstable;
    overlays = [
      fsh.overlays.default
      vscode-extensions.overlays.default
      aci.overlays.default
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena;
      })
      binary-ninja.overlays.default
    ];
    overlays-module = ({ nixpkgs, ... }: {
      nixpkgs.overlays = overlays;
    });
  in
  {
    nixosConfigurations.fern = nixpkgs-unstable.lib.nixosSystem {
      modules = [
        overlays-module
        ./hosts/fern/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
              ./home/ash/alex.nix
              ./home/ash/binaryninja.nix
              ./home/ash/desktop.nix
              ./home/ash/fern.nix
              ./home/ash/games.nix
              ./home/ash/intellij.nix
              ./home/ash/syncthing.nix
              ./home/ash/vscodium.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.alex = nixpkgs-unstable.lib.nixosSystem {
      modules = [
        overlays-module
        niri-flake.nixosModules.niri
        ./hosts/alex/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
              ./home/ash/alex.nix
              ./home/ash/desktop.nix
              ./home/ash/emacs.nix
#              ./home/ash/obs.nix
              #./home/ash/niri.nix
              ./home/ash/syncthing.nix
              ./home/ash/tpm-fido.nix
              ./home/ash/vscodium.nix
              ./home/ash/zoom.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.loona = nixpkgs-unstable.lib.nixosSystem {
      modules = [
        overlays-module
        niri-flake.nixosModules.niri
        ./hosts/loona/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
              ./home/ash/alex.nix
              ./home/ash/binaryninja.nix
              ./home/ash/desktop.nix
              ./home/ash/emacs.nix
              ./home/ash/gnome-builder.nix
              #./home/ash/niri.nix
              ./home/ash/intellij.nix
              ./home/ash/games.nix
              ./home/ash/syncthing.nix

              ./home/ash/vscodium.nix
              ./home/ash/zoom.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.lea = nixpkgs-stable.lib.nixosSystem {
      modules = [
        overlays-module
        ./hosts/lea/configuration.nix
        ./roles/coredns
        ./roles/postgres.nix
        home-manager-stable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
            ];
          };
        }
      ];
    };

    nixosConfigurations.amy = nixpkgs-stable.lib.nixosSystem {
      modules = [
        overlays-module
        aci.nixosModules.default
        agenix.nixosModules.default
        nixocaine.nixosModules.default

        ./modules

        ./hosts/amy/configuration.nix
        ./roles/conduit.nix
        ./roles/coredns
        ./roles/gts-sandbox.nix
        ./roles/iceshrimp.nix
        ./roles/iocaine
        ./roles/itwont-work.nix
        ./roles/keycloak.nix
        ./roles/mc-proxy.nix
        ./roles/munin-node.nix
        ./roles/podman.nix
        ./roles/postgres.nix
        ./roles/shorks-web.nix
        ./roles/youtrack.nix
        home-manager-stable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
            ];
          };
        }
      ];
    };

    nixosConfigurations.jessica = nixpkgs-stable.lib.nixosSystem {
      modules = [
        overlays-module
        aci.nixosModules.default
        agenix.nixosModules.default
        ./modules

        ./hosts/jessica/configuration.nix

        ./roles/bluesky-pds.nix
        ./roles/cryptpad.nix
        ./roles/docker-registry.nix
        #./roles/ergo.nix
        ./roles/garage.nix
        ./roles/grafana.nix
        ./roles/immich.nix
        ./roles/jenkins.nix
        ./roles/kanidm.nix
        ./roles/livekit.nix
        ./roles/mumble-server.nix

        ./roles/munin-node.nix
        ./roles/munin-server.nix

        ./roles/node-red.nix

        ./roles/postgres-jessica.nix
        ./roles/prometheus.nix

        ./roles/reposilite.nix
        ./roles/soju.nix
        ./roles/uptime-kuma.nix
        ./roles/vaultwarden.nix

        ./roles/podman.nix
        home-manager-stable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
            ];
          };
        }
      ];
    };

    nixosConfigurations.emira = nixpkgs-unstable.lib.nixosSystem {
      modules = [
        overlays-module
        ./hosts/emira/configuration.nix
        agenix.nixosModules.default
        ./common/generic-qemu.nix
      ];
    };

    nixosConfigurations.em = nixpkgs-unstable.lib.nixosSystem {
      modules = [
        overlays-module
        niri-flake.nixosModules.niri
        ./hosts/em/configuration.nix
        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ash = { ... }: {
            imports = [
              fsh.homeModules.fsh
              ./home/ash
              ./home/ash/niri.nix
              ./home/ash/desktop.nix
            ];
          };
        }
      ];
    };

    packages.x86_64-linux = {
      emira = nixos-generators.nixosGenerate {
        modules = [
          overlays-module
          ./hosts/emira/configuration.nix
        ];
        format = "qcow";
      };
    };
  } //
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs-unstable {
      inherit system;
      overlays = [agenix.overlays.default];
    };
  in
  {
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        pkgs.agenix
      ];
    };
  });
}
