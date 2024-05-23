{ inputs, pkgs, username, ... }:

let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./ags.nix
    ./btop.nix
    ./cava.nix
    ./foot.nix
    ./fuzzel.nix
    ./helix.nix
    ./hyprland.nix
    ./wlsunset.nix
    ./zsh.nix
    inputs.ags.homeManagerModules.default
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
  };

  home.file.".config/thefuck/settings.py".text = ''
    exclude_rules = [ "fix_file" ]
  '';

  gtk = {
    enable = true;
    cursorTheme.name = "capitaine-cursors";
    cursorTheme.package = pkgs.capitaine-cursors;
  };

  services.kdeconnect.enable = true;
  services.arrpc.enable = true;
  services.ssh-agent.enable = true;

  programs.home-manager.enable = true;
}
