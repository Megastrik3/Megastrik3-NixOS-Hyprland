{
  description = "Megastrik3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # Follow corresponding `release` branch from Home Manager
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      host = "default";
      username = "hudsonb";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # === ADDED ===
      # Create a separate pkgs instance specifically for CUDA packages.
      # This avoids rebuilding your entire system with cudaSupport = true.
      pkgs-cuda = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };
      # === END ADDED ===

    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
            inherit pkgs-cuda; # <-- Pass the CUDA-enabled pkgs instance here
          };
          modules = [
            ./hosts/${host}/config.nix
            ./modules/quickshell.nix
            ./noctalia/noctalia.nix
            home-manager.nixosModules.home-manager
            {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hudsonb = ./home.nix;
            }

            # Import the overlays from the new file
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ (import ./overlays) ];
            })
          ];
        };
      };
    };
}