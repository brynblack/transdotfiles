{ pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
    getty.greetingLine = ''[[[ \l @ \n (\s \r \m) ]]]''; # getty message
    gpm.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    kmscon = {
      enable = true;
      hwRender = true;
    };
    dbus.enable = true;
    haveged.enable = true;
    locate.enable = true;
    upower.enable = true;
    cron.enable = false;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    tlp.enable = true;
    packagekit.enable = true;
    fwupd.enable = true;
    udisks2.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        GatewayPorts = "clientspecified";
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      startWhenNeeded = true;
      allowSFTP = true;
      ports = [ 22 ];
      extraConfig = ''
        PrintLastLog no
      '';
    };
    xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;
      videoDrivers = [ "modesetting" "intel" ];
      libinput = {
        enable = true;
      };
      xkb = {
        variant = "colemak";
      };
      excludePackages = [ pkgs.xterm ];
      desktopManager = {
        xterm.enable = false;
      };
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        hiddenUsers = [ "root" "nobody" ]; # cannot login to root
      };
    };
  };
}
