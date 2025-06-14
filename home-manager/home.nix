{ pkgs, username, ... }:

let homeDirectory = "/home/${username}";
in {
  imports = [
    ./btop.nix
    ./hyprland.nix
    ./mako.nix
    ./waybar.nix
    ./wezterm.nix
    ./wlsunset.nix
    ./wofi.nix
    ./zsh.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 24;
    };
  };

  services = {
    blueman-applet.enable = true;
    ssh-agent.enable = true;
    arrpc = {
      enable = true;
      package = pkgs.callPackage ./arrpc { };
    };
  };

  programs.home-manager.enable = true;
}
