{ pkgs, ... }:

{
  programs = {
    anime-game-launcher.enable = true;
    gamemode.enable = true;
    steam.enable = true;
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
      settings = {
        format =
          pkgs.lib.concatStrings [ "[╭╴](238)$all" "[╰─>](238)$character" ];

        character = {
          success_symbol = "";
          error_symbol = "";
        };
      };
    };
    ssh.startAgent = true;
    hyprland.enable = true;
    obs-studio.enable = true;
    alvr = {
      enable = true;
      openFirewall = true;
    };
    localsend.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    adb.enable = true;
    nix-ld.enable = true;
    partition-manager.enable = true;
  };
}
