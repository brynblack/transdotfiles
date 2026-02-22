{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
    };
    displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "hyprland";
        customConfig = ''
          env=DMS_RUN_GREETER,1
          exec-once=hyprctl setcursor capitaine-cursors 24
          monitor=,preferred,auto,auto
          monitor=desc:ASUSTek COMPUTER INC VG279QM M3LMQS406491,preferred,0x0,1
          monitor=desc:Microstep MSI MP273A PB4H643C00347,1920x1080@100,1920x-350,1,transform,1
          input {
            accel_profile=flat
            follow_mouse=1
            kb_layout=us
            kb_variant=colemak
            repeat_delay=200
            repeat_rate=30
            sensitivity=-0.800000
          }
          misc {
            disable_hyprland_logo = true
          }
        '';
      };
      configHome = "/home/brynleyl";
    };
  };
}
