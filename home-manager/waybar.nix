{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
        "hyprland/workspaces" = { all-outputs = true; };
        "tray" = { spacing = 8; };
        spacing = 16;
      };
    };
    style = ''
      * {
        border: none;
        color: #cdd6f4 ;
        font-family: "CaskaydiaCove Nerd Font";
        font-size: 12px;
      }
      window#waybar {
        background-color: transparent;
      }
      .modules-left,
      .modules-center,
      .modules-right {
        background-color: rgba(30, 46, 46, 0.1176);
        border: 1px solid #35363e;
        border-radius: 12px;
      }
      .modules-center,
      .modules-right {
        padding-left: 8px;
        padding-right: 8px;
      }
    '';
  };
}
