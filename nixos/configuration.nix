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
    inputs.aagl.nixosModules.default
    inputs.xremap.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    SSH_ASKPASS_REQUIRE = "force";
    GSK_RENDERER = "ngl"; # temporary workaround for NVIDIA GTK bug
  };

  services = {
    upower.enable = true;
    gvfs.enable = true;
    xremap = {
      enable = true;
      serviceMode = "user";
      userName = "brynley";
      withWlroots = true;
      config = {
        modmap = [{
          name = "colemak->qwerty";
          application.only = [ "steam_app_275850" "steam_app_2399830" ];
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
        }];
      };
    };
  };

  system.stateVersion = "25.05";
}
