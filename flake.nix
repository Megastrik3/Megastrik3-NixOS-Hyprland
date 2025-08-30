{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
    #distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      host = "NixOS-Hyprland";
      username = "alice";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            # inputs.distro-grub-themes.nixosModules.${system}.default
            ./modules/quickshell.nix # quickshell module

            # --- START: Added overlay to fix i3ipc build ---
            ({ pkgs, ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  python3Packages = prev.python3Packages.overrideExtensions (
                    self: super: {
                      i3ipc = prev.python312Packages.i3ipc;
                    }
                  );
                })
              ];
            })
            # --- END: Added overlay ---
          ];
        };
      };
    };
}