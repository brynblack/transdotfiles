{
  pkgs,
  ...
}:

{
  programs = {
    alvr = {
      enable = true;
      openFirewall = true;
    };
    dconf.enable = true;
    direnv = {
      enable = true;
      silent = true;
    };
    dms-shell.enable = true;
    dsearch.enable = true;
    gamemode.enable = true;
    gnupg.agent.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    localsend.enable = true;
    obs-studio.enable = true;
    ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
      settings = {
        format = pkgs.lib.concatStrings [
          "[╭╴](238)$all"
          "[╰─>](238)$character"
        ];
        character = {
          error_symbol = "";
          success_symbol = "";
        };
      };
    };
    steam = {
      enable = true;
      protontricks.enable = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
