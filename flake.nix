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

    git-in = {
      url = "https://codeberg.org/ashhhleyyy/git-in/archive/trunk.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-utils.follows = "flake-utils";
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
    git-in,
    ...
  }:
  let
    home-manager = home-manager-unstable;
    overlays = [
      aci.overlays.default
      binary-ninja.overlays.default
      fsh.overlays.default
      git-in.overlays.default
      nixocaine.overlays.default
      vscode-extensions.overlays.default
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena;
      })
    ];
    overlays-module = ({ nixpkgs, ... }: {
      nixpkgs.overlays = overlays;
    });
    base-modules = [
      overlays-module
      aci.nixosModules.default
      agenix.nixosModules.default
      git-in.nixosModules.default
      niri-flake.nixosModules.niri
      nixocaine.nixosModules.default
      ./modules
    ];
  in
  {
    nixosConfigurations.fern = nixpkgs-unstable.lib.nixosSystem {
      modules = base-modules ++ [
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
      modules = base-modules ++ [
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
      modules = base-modules ++ [
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

    nixosConfigurations.amy = nixpkgs-stable.lib.nixosSystem {
      modules = base-modules ++ [
        ./hosts/amy/configuration.nix
        ./roles/iocaine
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
      modules = base-modules ++ [
        ./hosts/jessica/configuration.nix

        # ./roles/copyparty.nix
        #./roles/ergo.nix

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

    nixosConfigurations.em = nixpkgs-unstable.lib.nixosSystem {
      modules = base-modules ++ [
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
