{ inputs, pkgs, ... }:

let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in
{
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus"
        "swww init"
        "hyprctl setcursor 'capitaine-cursors' 24"
      ];

      exec = [
        "killall ags; GTK_THEME=adw-gtk3-dark ags"
      ];

      monitor = ",preferred,auto,auto";

      input = {
        kb_layout = "us";
        kb_variant = "colemak";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        accel_profile = "flat";
        sensitivity = 0;
        repeat_rate = 30;
        repeat_delay = 200;
      };

      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 1;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 10;
          passes = 3;
        };
        drop_shadow = true;
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(1a1a1aee)";
        "col.shadow_inactive" = "rgba(00000000)";
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.2, 0.9, 0.1, 1.05";
        animation = [
        "windows, 1, 3, myBezier"
        "windowsOut, 1, 2, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 1, default"
        "workspaces, 1, 6, myBezier"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0;
      };

      misc = {
        force_default_wallpaper = 0;
        animate_manual_resizes = true;
      };

      # windowrulev2 = "nomaximizerequest, class:.*";
      windowrulev2 = "float,class:(it.mijorus.smile),title:(Smile)";

      # Variables used for keybinds
      "$mod" = "ALT";
      "$terminal" = "foot";
      "$fileManager" = "nautilus";
      "$menu" = "fuzzel";

      bind =
        [
          # Generic binds
          "$mod, Q, exec, $terminal"
          "$mod, M, killactive," 
          "$mod + SUPER, Y, exit," 
          "$mod, F, exec, $fileManager"
          "$mod, SEMICOLON, togglefloating," 
          "$mod, SPACE, exec, $menu"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, K, fullscreen, 0"

          # Screenshot using $mod + prtsc
          "$mod, PRINT, exec, grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d')_$(date +'%H%M%S.png') | wl-copy && notify-send \"screenshot saved :3\" || echo \"uh-oh, something went wrong :(\""

          # Scroll through existing workspaces with $mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Control MPRIS with media keys
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"

          # Control brightness with brightness keys
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"

          # Toggle audio mute
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

          # Toggle microphone mute
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );

      binde =
        [
          # Move focus with mainMod + arrow keys
          "$mod, n, movefocus, l"
          "$mod, o, movefocus, r"
          "$mod, i, movefocus, u"
          "$mod, e, movefocus, d"

          # Resize the active window with $mod + CTRL + direction keys
          "$mod + CTRL, n, resizeactive, -25 0"
          "$mod + CTRL, o, resizeactive, 25 0"
          "$mod + CTRL, i, resizeactive, 0 -25"
          "$mod + CTRL, e, resizeactive, 0 25"

          # Move active window with $mod + SHIFT + direction keys
          "$mod + SHIFT, n, movewindow, l"
          "$mod + SHIFT, o, movewindow, r"
          "$mod + SHIFT, i, movewindow, u"
          "$mod + SHIFT, e, movewindow, d"

          # Control volume with volume keys
          ", XF86AudioLowerVolume, exec, wpctl set-volume --limit 1.0 @DEFAULT_SINK@ 2%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.0 @DEFAULT_SINK@ 2%+"
        ];

      bindm =
        [
          # Move/resize windows with $mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
    };
  };
}

