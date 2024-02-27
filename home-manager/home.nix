{ pkgs, username, ... }:

let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./ags.nix      # GTK Widgets
    ./btop.nix     # Process monitor
    ./cava.nix     # Audio visualiser
    ./foot.nix     # Terminal
    ./fuzzel.nix   # Application launcher
    ./helix.nix    # IDE/Text editor
    ./hyprland.nix # Wayland compositor
    ./packages.nix # Custom packages
    ./wlsunset.nix # Night light
  ];

  home = {
    inherit username homeDirectory;

    sessionVariables = {
      XCURSOR_THEME = "capitaine-cursors";
      XCURSOR_SIZE = "24";
    };

    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
      gtk.enable = true;
    };
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  services.kdeconnect.enable = true;

  gtk = {
    enable = true;
    font.name = "Cantarell";
    theme.name = "adw-gtk3-dark";
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    iconTheme.name = "Adwaita";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}

