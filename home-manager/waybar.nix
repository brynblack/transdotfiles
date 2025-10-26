{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        output = [ "DP-2" ];
        position = "top";
        margin = "6 6 0 6";
        height = 32;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" ];
        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
        };
        "clock" = { tooltip-format = "{:%a %d %b}"; };
        "tray" = { spacing = 8; };
        spacing = 16;
      };
    };
  };
}
