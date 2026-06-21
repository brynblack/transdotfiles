{
  services.xremap = {
    enable = true;
    serviceMode = "user";
    userName = "brynley";
    withWlroots = true;
    config = {
      modmap = [
        {
          name = "colemak->qwerty";
          application.only = [
            "OxygenNotIncluded"
            "PathOfTitans-Linux-Shipping"
            "steam_app_1172620"
            "steam_app_1604270"
            "steam_app_1766740"
            "steam_app_2399830"
            "steam_app_275850"
            "steam_app_3041230"
            "steam_app_3240220"
            "steam_app_376210"
            "steam_app_526870"
            "steam_app_648350"
            "steam_app_881100"
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
}
