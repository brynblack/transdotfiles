{ pkgs, ... }:

{
  home.packages = with pkgs; with gnome; [
    # Misc
    adw-gtk3        # libadwaita theme for GTK3 apps
    capitaine-cursors
    swww            # wallpaper utility
    brightnessctl   # brightness control
    grim            # screenshot tool
    slurp           # area selection
    playerctl       # MPRIS cli tool
    cava            # audio visualiser
    wl-clipboard    # wayland clipboard
    wlsunset        # night light
    btop            # system monitor
    neofetch        # fancy information viewer
    thefuck         # command autocorrection
    rustup          # rust toolchain manager
    pulumi          # orchestration tool
    bun             # the best JS package manager
    eza             # fancy ls tool in Rust
    ffmpeg          # media transpolation tool
    xdg-desktop-portal-gtk # ???????

    # Applications
    firefox
    spotify
    vesktop
    gnome-control-center
    gnome-settings-daemon
    gradience
    nautilus
    zoom-us
  ];
}
