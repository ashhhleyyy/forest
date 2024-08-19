{
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    lix-module-stable = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    lix-module-unstable = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
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
  };

  outputs = {
    self,
    nixpkgs-stable, nixpkgs-unstable,
    lix-module-stable, lix-module-unstable,
    home-manager-stable, home-manager-unstable,
    nixos-generators,
    fsh,
    vscode-extensions,
    agenix,
    niri-flake,
    ...
  }:
  let
    home-manager = home-manager-unstable;
    overlays = [
      fsh.overlays.default
      vscode-extensions.overlays.default
    ];
    overlays-module = ({ nixpkgs, ... }: {
      nixpkgs.overlays = overlays;
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
              ./home/ash/niri.nix
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
              ./home/ash/niri.nix
              ./home/ash/obs.nix
              ./home/ash/intellij.nix
              ./home/ash/lutris.nix

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
        agenix.nixosModules.default
        ./hosts/amy/configuration.nix
        ./roles/conduit.nix
        ./roles/coredns
        ./roles/iceshrimp.nix
        ./roles/keycloak.nix
        ./roles/mc-proxy.nix
        ./roles/podman.nix
        ./roles/postgres.nix
        ./roles/zulip.nix
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

    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs-unstable {
        system = "x86_64-linux";
      };
    in
      pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        agenix.packages.${system}.default
      ];
    };
  };
}
