{
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-22.11";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, fsh, home-manager-unstable, nixos-generators, vscode-extensions, ... }:
  let
    home-manager = home-manager-unstable;
    overlays = [
      fsh.overlays.default
      vscode-extensions.overlays.default
      (final: prev: {
        ndi = prev.ndi.overrideAttrs (self: super: {
        version = "5.5.4";
        src = prev.pkgs.requireFile rec {
          name = "${self.installerName}.tar.gz";
          sha256 = "sha256:7e5c54693d6aee6b6f1d6d49f48d4effd7281abd216d9ff601be2d55af12f7f5";
          message = self.installerName;
          };
          unpackPhase = "unpackFile \${src}\necho y | ./${self.installerName}.sh\nsourceRoot=\"NDI SDK for Linux\";\n";
          installPhase = ''
          mkdir $out
    mv bin/x86_64-linux-gnu $out/bin
    for i in $out/bin/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
    done
    patchelf --set-rpath "${prev.avahi}/lib:${prev.stdenv.cc.libc}/lib" $out/bin/ndi-record
    mv lib/x86_64-linux-gnu $out/lib
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${prev.avahi}/lib:${prev.stdenv.cc.libc}/lib" "$i"
    done
    mv include examples $out/
    mkdir -p $out/share/doc/${self.pname}-${self.version}
    mv licenses $out/share/doc/${self.pname}-${self.version}/licenses
    mv documentation/* $out/share/doc/${self.pname}-${self.version}/
          '';
          }
          );
      })
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
#              ./home/ash/obs.nix
              ./home/ash/tpm-fido.nix
              ./home/ash/vscodium.nix
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
