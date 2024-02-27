{ pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./audio.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./users.nix
  ];

  nix = {
    daemonCPUSchedPolicy = "idle";
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
  };

  console.keyMap = "colemak";
  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Sydney";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    coreutils       # basic shell utilities
    cryptsetup      # luks
    dmidecode       # dmidecode
    efibootmgr      # efi management
    gawk            # awk
    git             # version control
    gnupg           # encryption/decryption/signing
    gnugrep         # grep
    gnused          # sed
    gptfdisk        # disk partitioning
    helix           # text editor
    hdparm          # disk info
    home-manager    # nix-managed home configuration
    iproute         # ip, tc
    iw              # wireless configuration
    lm_sensors      # fan monitoring
    lshw            # lshw
    mkpasswd        # mkpasswd
    mtools          # disk labelling
    ncurses         # tput (terminal control)
    nettools        # hostname, ifconfig
    openssh         # ssh
    pciutils        # lspci, setpci
    procps          # ps, top, pidof, vmstat, slabtop, skill, w
    psmisc          # fuser, killall, pstree, peekfd
    shadow          # passwd, su
    smartmontools   # disk monitoring
    usbutils        # lsusb
    utillinux       # linux system utilities
  ];

  fonts = {
    packages = with pkgs; [
      cantarell-fonts # main ui font
      cascadia-code   # monospace
    ];
  };

  virtualisation.docker.enable = true;

  security = {
    polkit.enable = true;
    sudo = {
      extraConfig = ''
        Defaults umask = 0022
        Defaults umask_override
      '';
    };
  };

  system.stateVersion = "23.11";
}
