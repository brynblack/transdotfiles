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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
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
  };

  programs.home-manager.enable = true;
}
