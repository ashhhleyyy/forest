{
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    lix-module-stable = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    lix-module-unstable = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "git+https://git.ashhhleyyy.dev/ash/aci";
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

    nixpkgs-olympus.url = "github:Petingoso/nixpkgs/olympus";
  };

  outputs = {
    self,
    nixpkgs-stable, nixpkgs-unstable,
    lix-module-stable, lix-module-unstable,
    home-manager-stable, home-manager-unstable,
    nixos-generators,
    fsh,
    aci,
    vscode-extensions,
    agenix,
    niri-flake,
    nixpkgs-olympus,
    ...
  }:
  let
    home-manager = home-manager-unstable;
    overlays = [
      fsh.overlays.default
      vscode-extensions.overlays.default
      aci.overlays.default
      (final: prev: {
        inherit (nixpkgs-olympus.legacyPackages.${prev.system}) olympus;
      })
    ];
    overlays-module = ({ nixpkgs, ... }: {
      nixpkgs.overlays = overlays;
    });
    pds-overlay-module = ({ nixpkgs, ... }: {
      imports = ["${nixpkgs-unstable}/nixos/modules/services/web-apps/pds.nix"];
    
      nixpkgs.overlays = [
        (final: prev: {
          inherit (nixpkgs-unstable.legacyPackages.${prev.system}) pds pdsadmin;
        })
      ];
    });
  in
  {
    nixosConfigurations.fern = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
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
              ./home/ash/desktop.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.alex = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
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
      system = "x86_64-linux";
      modules = [
        overlays-module
        niri-flake.nixosModules.niri
        ./hosts/loona/configuration.nix
        home-manager.nixosModules.home-manager
        lix-module-unstable.nixosModules.default
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
              ./home/ash/gnome-builder.nix
              #./home/ash/niri.nix
              ./home/ash/obs.nix
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
      system = "x86_64-linux";
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
      system = "x86_64-linux";
      modules = [
        overlays-module
        aci.nixosModules.default
        agenix.nixosModules.default
        ./modules

        ./hosts/amy/configuration.nix
        ./roles/conduit.nix
        ./roles/coredns
        ./roles/gts-sandbox.nix
        ./roles/iceshrimp.nix
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
      system = "x86_64-linux";
      modules = [
        overlays-module
        aci.nixosModules.default
        agenix.nixosModules.default
        pds-overlay-module
        ./modules

        ./hosts/jessica/configuration.nix

        ./roles/bluesky-pds.nix

        ./roles/cryptpad.nix

        ./roles/grafana.nix
        ./roles/jenkins.nix

        ./roles/mumble-server.nix

        ./roles/munin-node.nix
        ./roles/munin-server.nix

        ./roles/soju.nix

        ./roles/uptime-kuma.nix

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
      system = "x86_64-linux";
      modules = [
        overlays-module
        ./hosts/emira/configuration.nix
        agenix.nixosModules.default
        ./common/generic-qemu.nix
      ];
    };

    nixosConfigurations.em = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
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
        system = "x86_64-linux";
        modules = [
          overlays-module
          ./hosts/emira/configuration.nix
        ];
        format = "qcow";
      };
    };
  } //
  (let
    pkgs = import nixpkgs-unstable {
      system = "x86_64-linux";
    };
  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        agenix.packages.${system}.default
      ];
    };
  });
}
