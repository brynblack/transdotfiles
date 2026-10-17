{
  pkgs,
  ...
}:

{
  imports = [
    ./git.nix
    ./hyprland
    ./mangohud.nix
    ./nixvim
    ./noctalia
    ./wezterm
    ./zsh.nix
  ];

  home = {
    stateVersion = "26.05";
    pointerCursor = {
      enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
