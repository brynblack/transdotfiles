{ inputs, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./users.nix
    inputs.xremap.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SSH_ASKPASS_REQUIRE = "force";
    XCURSOR_SIZE = "24";
  };

  services = {
    upower.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    accounts-daemon.enable = true;
    xremap = {
      enable = true;
      serviceMode = "user";
      userName = "brynley";
      withWlroots = true;
      config = {
        modmap = [
          {
            name = "colemak->qwerty";
            application.only = [
              "steam_app_275850"
              "steam_app_2399830"
              "steam_app_648350"
              "steam_app_376210"
              "steam_app_1604270"
              "steam_app_1766740"
              "steam_app_881100"
              "steam_app_3240220"
              "OxygenNotIncluded"
            ];
            remap = {
              # top row
              q = "q";
              w = "w";
              f = "e";
              p = "r";
              g = "t";
              j = "y";
              l = "u";
              u = "i";
              y = "o";
              semicolon = "p";

              # home row
              a = "a";
              r = "s";
              s = "d";
              t = "f";
              d = "g";
              h = "h";
              n = "j";
              e = "k";
              i = "l";
              o = "semicolon";

              # bottom row
              z = "z";
              x = "x";
              c = "c";
              v = "v";
              b = "b";
              k = "n";
              m = "m";
              comma = "comma";
              dot = "dot";
              slash = "slash";

              # punctuation / brackets
              minus = "minus";
              equal = "equal";
              leftbrace = "leftbrace";
              rightbrace = "rightbrace";
              apostrophe = "apostrophe";
              backslash = "backslash";
            };
          }
        ];
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  system.stateVersion = "25.05";
}
