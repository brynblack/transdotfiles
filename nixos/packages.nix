{ pkgs, ... }:

with pkgs;
with gnome;
with nodePackages_latest;
with python311Packages; 
let
  mpvpaper = pkgs.callPackage ./mpvpaper {};
  gradience = pkgs.callPackage ./gradience {};
in
{
  environment.systemPackages = [
    nil
    typescript-language-server
    ts-node
    clang-tools
    python-lsp-server
    wofi

    hyprlock
    ripgrep
    prismlauncher
    docker-compose
    docker
    usbutils
    gcc
    rustup
    bottles
    pulseaudio
    capitaine-cursors
    godot_4
    git
    helix
    foot
    swww
    fuzzel
    wl-clipboard
    playerctl
    pfetch
    brave
    home-manager
    mpvpaper
    cava
    eza
    vesktop
    btop
    steam
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
