{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hyprland
    ./nixvim
    ./wezterm
    ./zsh.nix
    inputs.nixvim.homeModules.nixvim
  ];

  home = {
    stateVersion = "26.05";
    file.".icons/default".source = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
