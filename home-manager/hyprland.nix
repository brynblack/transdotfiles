{ config, ... }:

{
  home.file = (builtins.listToAttrs (builtins.map (x: {
    name = ".config/hypr/scripts/" + x + ".sh";
    value = { source = ./scripts/${x}.sh; };
  }) [ "autostart" "brightness" "filter" "media" "powermenu" "volume" ]));

  services = {
    swww.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    hyprsunset.enable = true;
  };

  programs.hyprlock = { enable = true; };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [ "~/.config/hypr/scripts/autostart.sh" ];

      monitor = [
        ",preferred,auto,auto"
        "desc:ASUSTek COMPUTER INC VG279QM M3LMQS406491,preferred,0x0,1"
        "desc:Microstep MSI MP273A PB4H643C00347,1920x1080@100,1920x-350,1,transform,1"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "colemak";
        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = -0.8;
        repeat_rate = 30;
        repeat_delay = 200;
      };

      cursor.no_hardware_cursors = 1;

      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 1;
        layout = "dwindle";
        allow_tearing = false;

        "col.active_border" = "rgba(35363Eff)";
        "col.inactive_border" = "rgba(35363Eff)";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 10;
          passes = 3;
          input_methods = true;
          input_methods_ignorealpha = 0.0;
        };
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

      xwayland = { force_zero_scaling = true; };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      misc = {
        force_default_wallpaper = 0;
        animate_manual_resizes = true;
      };

      layerrule = [
        "blur, notifications"
        "ignorealpha 0.05, notifications"
        "blur, waybar"
        "ignorealpha 0.05, waybar"
        "blur, wofi"
        "ignorealpha 0.05, wofi"
        "noanim, wofi"
      ];

      windowrule = [
        "float, title:OpenRGB"
        "float, class:org.fcitx."
        "float, class:.blueman-manager-wrapped"
        "persistentsize, floating:1"
      ];

      workspace = [ "1, monitor:DP-2" "2, monitor:HDMI-A-1" ];

      # Variables used for keybinds
      "$mod" = "mod4";
      "$terminal" = "wezterm";
      "$fileManager" = "nautilus";
      "$menu" = "wofi";

      bind = [
        # Generic binds
        "$mod, ESCAPE, exec, ~/.config/hypr/scripts/powermenu.sh"
        "$mod, Q, exec, $terminal"
        "$mod, M, killactive,"
        "$mod, F, exec, $fileManager"
        "$mod, SEMICOLON, togglefloating,"
        "$mod, SPACE, exec, pkill wofi; $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, K, fullscreen, 0"
        "$mod, L, exec, loginctl lock-session"
        "$mod, BACKSLASH, exec, ~/.config/hypr/scripts/filter.sh"

        # Rectangluar screenshot using $mod + SHIFT + R
        ''
          $mod + SHIFT, R, exec, grim -g "$(slurp -d)" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d')_$(date +'%H%M%S.png') | wl-copy && notify-send "screenshot saved :3" || echo "uh-oh, something went wrong :("''

        # Screenshot monitor using $mod + prtsc
        ''
          $mod + SHIFT, P, exec, grim -g "$(slurp -d -o)" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d')_$(date +'%H%M%S.png') | wl-copy && notify-send "screenshot saved :3" || echo "uh-oh, something went wrong :("''

        # Scroll through existing workspaces with $mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Control MPRIS with media keys
        ", XF86AudioPrev, exec, ~/.config/hypr/scripts/media.sh previous"
        ", XF86AudioPlay, exec, ~/.config/hypr/scripts/media.sh play-pause"
        ", XF86AudioNext, exec, ~/.config/hypr/scripts/media.sh next"

        # Toggle audio mute
        ", XF86AudioMute, exec, ~/.config/hypr/scripts/volume.sh"

        # Color picker
        "$mod, HOME, exec, hyprpicker -a"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 10));

      binde = [
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

        # Move active window granularly with $mod + CTRL + SHIFT + direction keys
        "$mod + CTRL + SHIFT, n, moveactive, -50 0"
        "$mod + CTRL + SHIFT, o, moveactive, 50 0"
        "$mod + CTRL + SHIFT, i, moveactive, 0 -50"
        "$mod + CTRL + SHIFT, e, moveactive, 0 50"

        # Control volume with volume keys
        ", XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/volume.sh 2%-"
        ", XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/volume.sh 2%+"

        # Control brightness with $mod + volume keys
        "$mod, XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/brightness.sh -2"
        "$mod, XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/brightness.sh +2"
      ];

      bindm = [
        # Move/resize windows with $mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
