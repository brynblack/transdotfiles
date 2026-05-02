{ pkgs, inputs, ... }:

with pkgs;
{
  environment.systemPackages = [
    home-manager # self-explanatory

    ## Formatting
    nixfmt-tree # nix formatter
    prettier # general formatter

    ## Development/CLI tools

    openal # openrgb plugin support
    icu # this is probably important
    icu.dev # this too
    gcc # compiler
    wl-clipboard # clipboard support
    unzip # unzipping archives
    wget # downloading files
    npm-check-updates # bulk-updating npm packages
    cava # audio visualizer
    eza # ls
    git # git
    pfetch # neofetch
    grim
    slurp
    hyprshot
    ripgrep
    fd
    libnotify
    ffmpeg
    exiftool
    rsgain
    playerctl
    hyprpicker # color picker
    alsa-utils # alsa controls
    usbutils # lsusb, etc
    yubikey-manager # yubikey manager
    sshfs # ssh filesystem
    wev # key utility
    sbctl # secure boot
    entr # fs watch
    adw-gtk3
    hugin
    enblend-enfuse
    dig
    python3
    claude-code

    ## Theming
    dwt1-shell-color-scripts # fancy terminal colors
    kdePackages.breeze-icons
    kdePackages.breeze
    capitaine-cursors

    ## Disabled packages
    # ukmm # BOTW
    # cemu # BOTW

    via # keyboard customiser
    kdePackages.qt6ct # qt5/qt6 customiser
    anki # SRS app
    mpv # video player
    inkscape # SVG editing
    darktable # RAW editing
    libreoffice-qt # document editing
    pavucontrol # audio manager
    loupe # image viewer
    nautilus # file manager
    upscaler # image upscaling
    prismlauncher # minecraft
    vintagestory # vintage story
    osu-lazer-bin # osu!
    vesktop # discord
    element-desktop # private messaging
    krita # drawing
    feishin # music
    kdePackages.kdenlive # video editor
    audacity # audio editor
    (blender.override { cudaSupport = true; })
    wayvr # VR desktop manager
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default # browser
    tor-browser # anonymous browsing
    fragments # torrenting
    proton-vpn # vpn
    mangohud # perf profiler
    neovide # code editor
  ];

  fonts.packages = [
    noto-fonts-cjk-sans
    lato
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
