{ pkgs, ... }:

with pkgs;
with gnome;
with nodePackages_latest;
with python311Packages; 
let
  gradience = pkgs.callPackage ./gradience {};
in
{
  environment.systemPackages = [
    nil
    typescript-language-server
    ts-node
    clang-tools
    python-lsp-server
    java-language-server

    wofi
    killall
    cemu
    obs-studio
    hyprlock
    ripgrep
    prismlauncher
    osu-lazer-bin
    docker-compose
    docker
    usbutils
    gcc
    rustup
    bottles
    pulseaudio
    capitaine-cursors
    git
    helix
    foot
    swww
    wl-clipboard
    playerctl
    pfetch
    brave
    home-manager
    cava
    eza
    vesktop
    btop
    adw-gtk3
    helvum
    grim
    slurp
    nautilus
    ffmpeg
    cudatoolkit
    gradience
    loupe
    mpv
    scrcpy
    tty-clock
    spotify
    libnotify
    dwt1-shell-color-scripts
    gnome-control-center
    gnome-settings-daemon
  ]; 

  fonts.packages = [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    source-han-sans-japanese
    source-han-serif-japanese

    cantarell-fonts
    nerdfonts
  ];
}
