{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "brynleyl";
      overlay = self: super: {
        openimagedenoise = super.openimagedenoise.overrideAttrs (oldAttrs: {
          patches = [
            (builtins.fetchurl {
              url = "https://raw.githubusercontent.com/NixOS/nixpkgs/a391915df5fa365cb461a0da154fe3a57118c732/pkgs/by-name/op/openimagedenoise/cuda.patch";
              sha256 = "sha256:1p3sbc3yzlxjscn3jgbvk5vwvz2p9k6fsn9x631dlqk7r2i4nysj";
            })
          ];
        });
      };
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [ ./nixos/configuration.nix ];
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            overlay
          ];
        };
      };
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs system username; };
        modules = [ ./home-manager/home.nix ];
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
