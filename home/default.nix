{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./bat.nix
    ./git.nix
    ./gpg.nix
    ./hyprland
    ./kitty.nix
    ./mangohud.nix
    ./nixvim
    ./noctalia
    ./tmux.nix
    ./zsh.nix
  ];

  home = {
    stateVersion = "26.05";
    preferXdgDirectories = true;
    sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
    pointerCursor = {
      enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
      # Still linked into $XDG_DATA_HOME/icons, which libXcursor searches by
      # default, so the ~/.icons copy is redundant.
      dotIcons.enable = false;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
