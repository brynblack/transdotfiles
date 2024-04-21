{ pkgs, ... }:

with pkgs;
with gnome;
let
  mpvpaper = pkgs.callPackage ./mpvpaper {};
  gradience = pkgs.callPackage ./gradience {};
  blender = pkgs.blender.override {
    cudaSupport = true;
  };
in
{
  environment.systemPackages = [
    capitaine-cursors
    blender
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
