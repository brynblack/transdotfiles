{ pkgs, system, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./users.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
  };

  nix = {
    nixPath = [
      "nixpkgs=/etc/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 7;

    settings = {
      max-jobs = 16;
      cores = 0;
      sandbox = true;
      extra-sandbox-paths = [ "/run/keys" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      experimental-features = "nix-command flakes";
    };

    extraOptions = ''
      fsync-metadata = true
    '';
  };

  time.timeZone = "Australia/Sydney";

  console = {
    keyMap = "colemak";
  };

  i18n = {
    defaultLocale = "en_AU.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git # DO NOT EVER REMOVE GIT FROM HERE.
    home-manager

    coreutils       # basic shell utilities
    gnused          # sed
    gnugrep         # grep
    gawk            # awk
    ncurses         # tput (terminal control)
    iw              # wireless configuration
    iproute         # ip, tc
    nettools        # hostname, ifconfig
    dmidecode       # dmidecode
    lshw            # lshw
    pciutils        # lspci, setpci
    usbutils        # lsusb
    utillinux       # linux system utilities
    cryptsetup      # luks
    mtools          # disk labelling
    smartmontools   # disk monitoring
    gptfdisk        # disk partitioning
    lm_sensors      # fan monitoring
    procps          # ps, top, pidof, vmstat, slabtop, skill, w
    psmisc          # fuser, killall, pstree, peekfd
    shadow          # passwd, su
    mkpasswd        # mkpasswd
    efibootmgr      # efi management
    openssh         # ssh
    gnupg           # encryption/decryption/signing
    hdparm          # disk info
    git             # needed for content addressed nixpkgs

    libnotify       # notification utility
    btop            # system monitor
    neofetch        # fancy information viewer
    thefuck         # command autocorrection
    rustup          # rust toolchain manager
    gcc             # c/c++ compiler
    pulumi          # orchestration tool
    bun             # the best JS package manager
    deno            # a slightly worse one (for now)
    nodejs          # ?????????? why
    steam-run       # this should not be used lol
    adw-gtk3        # libadwaita theme for GTK3 apps
    eza             # fancy ls tool in Rust
    helix           # text editor
    wlsunset
    cava

    brightnessctl
    grim
    slurp
    wl-clipboard
    playerctl

    xdg-desktop-portal-gtk #?????
    polkit #?????
    nodePackages_latest.typescript-language-server #?????
    nodePackages_latest.ts-node #?????

    # GUI Apps
    gnome.gnome-control-center
    gnome.gnome-settings-daemon
    gnome.gnome-software
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
  ];

  environment.variables = {
    "TMPDIR" = "/tmp";
    "VDPAU_DRIVER" = "va_gl";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      cantarell-fonts
      cascadia-code
    ];
    fontDir.enable = true;
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
  };

  security = {
    sudo = {
      wheelNeedsPassword = true;
      extraConfig = ''
        Defaults umask = 0022
        Defaults umask_override
      '';
    };
    polkit.enable = true;
  };

  system.stateVersion = "23.11";
}
