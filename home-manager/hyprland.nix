{ pkgs, ... }:

{
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  home.file.".icons/default".source = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors";

  home.file.".config/hypr/hyprlock.conf".text = ''
    background {
      monitor =
      path = /home/brynleyl/Pictures/Wallpapers/branch.jpg

      blur_passes = 3 # 0 disables blurring
      blur_size = 7
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }
    input-field {
      monitor =
      size = 200, 50
      outline_thickness = 3
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = rgb(49482d)
      inner_color = rgb(1c1c16)
      font_color = rgb(150, 150, 150)
      fade_on_empty = true
      fade_timeout = 250 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i>⋆𐙚₊˚⊹♡ enter pass ⋆𐙚₊˚⊹♡</i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = -1 # -1 means complete rounding (circle/oval)
      check_color = rgb(204, 136, 34)
      fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = -1
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = 0, -20
      halign = center
      valign = center
    }  
  '';

  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    TERMINAL = "foot";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus"
        "swww-daemon"
        "hyprctl setcursor 'capitaine-cursors' 24"
        "openrgb --profile Default --startminimized"
      ];

      exec = [
        "ags --quit; GTK_THEME=adw-gtk3-dark ags"
      ];

      monitor = [
        ",preferred,auto,auto"
        "Unknown-1,disabled"
        "desc:ASUSTek COMPUTER INC VG279QM M3LMQS406491,preferred,0x0,1"
        "desc:Microstep MSI MP273A PB4H643C00347,1920x1080@100,1920x-350,1,transform,1"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "colemak";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        accel_profile = "flat";
        sensitivity = -0.7;
        repeat_rate = 30;
        repeat_delay = 200;
      };

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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0;
      };

      misc = {
        force_default_wallpaper = 0;
        animate_manual_resizes = true;
      };

      # Variables used for keybinds
      "$mod" = "ALT";
      "$terminal" = "foot";
      "$fileManager" = "nautilus";
      "$menu" = "wofi -I -M fuzzy -S drun";

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
          "$mod, L, exec, hyprlock"

          # Rectangluar screenshot using $mod + SHIFT + R
          "$mod + SHIFT, R, exec, grim -g \"$(slurp -d)\" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d')_$(date +'%H%M%S.png') | wl-copy && notify-send \"screenshot saved :3\" || echo \"uh-oh, something went wrong :(\""

          # Screenshot monitor using $mod + prtsc
          "$mod, PRINT, exec, grim -g \"$(slurp -d -o)\" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d')_$(date +'%H%M%S.png') | wl-copy && notify-send \"screenshot saved :3\" || echo \"uh-oh, something went wrong :(\""

          # Scroll through existing workspaces with $mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Control MPRIS with media keys
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"

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

          # Move active window granularly with $mod + CTRL + SHIFT + direction keys
          "$mod + CTRL + SHIFT, n, moveactive, -50 0"
          "$mod + CTRL + SHIFT, o, moveactive, 50 0"
          "$mod + CTRL + SHIFT, i, moveactive, 0 -50"
          "$mod + CTRL + SHIFT, e, moveactive, 0 50"

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

