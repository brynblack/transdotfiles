{ pkgs, inputs, ... }:

let
  blender = pkgs.blender.override { cudaSupport = true; };
  zen-browser = inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
with pkgs;
{
  environment.systemPackages = [
    adw-gtk3 # theming
    anki # srs app
    audacity # audio editor
    blender # 3d modelling
    capitaine-cursors # cursor package
    claude-code # ai agent
    darktable # raw editing
    dwt1-shell-color-scripts # shell eye candy
    element-desktop # private messaging
    enblend-enfuse # darktable plugin
    eza # ls replacement
    fd # telescope.nvim find_files
    feishin # music
    fragments # torrenting
    git # git
    hugin # darktable plugin
    hyprpicker # color picker
    hyprshot # screenshot utility
    inkscape # svg editing
    kdePackages.breeze # theming
    kdePackages.breeze-icons # theming
    kdePackages.kdenlive # video editor
    kdePackages.qt6ct # qt5/qt6 customiser
    krita # drawing
    libreoffice-qt # productivity suite
    loupe # image viewer
    mangohud # perf profiler
    mpv # video player
    nautilus # file manager
    neovide # code editor
    nixfmt-tree # nix formatter
    osu-lazer-bin # osu!
    pfetch # neofetch replacement
    prismlauncher # minecraft
    proton-vpn # vpn
    python3 # python interpreter
    ripgrep # telescope.nvim live_grep
    sbctl # secure boot
    sshfs # ssh filesystem
    tor-browser # anonymous browsing
    unzip # unzipping archives
    upscaler # image upscaling
    usbutils # lsusb, etc
    vesktop # discord
    via # keyboard customiser
    vintagestory # vintage story
    wayvr # vr desktop manager
    wev # key utility
    wget # downloading files
    wl-clipboard # clipboard support
    yubikey-manager # yubikey manager
    zen-browser # browser
  ];

  fonts.packages = [
    noto-fonts-cjk-sans
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
