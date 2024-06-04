{
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
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
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, fsh, home-manager-stable, home-manager-unstable, nixos-generators, vscode-extensions, ... }:
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
              ./home/ash/tpm-fido.nix
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
        ./hosts/amy/configuration.nix
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

    nixosConfigurations.emira = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        overlays-module
        ./hosts/emira/configuration.nix
        ./common/generic-qemu.nix
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
  };
}
