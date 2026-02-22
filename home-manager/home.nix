{
  pkgs,
  username,
  inputs,
  ...
}:

let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./hyprland.nix
    ./nixvim/nixvim.nix
    ./wezterm.nix
    ./zsh.nix
    inputs.nixvim.homeModules.nixvim
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.file.".icons/default".source = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors";

  services = {
    blueman-applet.enable = true;
    ssh-agent.enable = true;
  };

  programs.home-manager.enable = true;
}
