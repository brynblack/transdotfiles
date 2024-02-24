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
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  services = {
    kdeconnect = {
      enable = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}

