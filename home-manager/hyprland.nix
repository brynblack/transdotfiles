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

  programs = {
    hyprlock.enable = true;
    hyprshot.enable = true;
  };

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
        border_size = 0;
        layout = "dwindle";
        allow_tearing = false;
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
        shadow.enabled = false;
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

      layerrule = [ "noanim, wofi" ];

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
      "$screenshotDir" = "HYPRSHOT_DIR=~/Pictures/Screenshots";
      "$screenshotName" = "$(date +'Screenshot_%Y%m%d_%H%M%S.png')";

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

        # Screenshot region using $mod + SHIFT + R
        "$mod + SHIFT, R, exec, $screenshotDir hyprshot -z -f $screenshotName -m region"

        # Screenshot window using $mod + SHIFT + W
        "$mod + SHIFT, W, exec, $screenshotDir hyprshot -z -f $screenshotName -m window"

        # Screenshot output using $mod + SHIFT + P
        "$mod + SHIFT, P, exec, $screenshotDir hyprshot -z -f $screenshotName -m output"

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
        # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
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
