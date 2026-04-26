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
    stateVersion = "26.05";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  home.file.".icons/default".source = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors";

  services = {
    ssh-agent.enable = true;
  };

  programs.home-manager.enable = true;
}
