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
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      # Upstream's packages/nix pins millennium-src to a stale commit whose
      # CMake ignores -DMILLENNIUM_LINUX_X64=ON and forces -m32 on the 64-bit
      # build. Track the same branch as the recipe so the two stay in sync.
      inputs.millennium-src.follows = "millennium-src";
    };
    millennium-src = {
      url = "github:SteamClientHomebrew/Millennium";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./system
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Move a pre-existing file aside instead of failing activation.
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs; };
              users.brynleyl = import ./home;
            };
          }
        ];
      };
    };
}
