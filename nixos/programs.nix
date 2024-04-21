{ pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
      settings = {
        format = pkgs.lib.concatStrings [
          "[╭╴](238)$all"
          "[╰─>](238)$character"
        ];

        character = {
          success_symbol = "";
          error_symbol = "";
        };
      };
    };
    thefuck.enable = true;
    kdeconnect.enable = true;
    alvr = {
      enable = true;
      openFirewall = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    adb.enable = true;
  };
}
