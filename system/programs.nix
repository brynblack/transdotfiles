{
  pkgs,
  ...
}:

{
  programs = {
    dconf.enable = true;
    direnv = {
      enable = true;
      silent = true;
    };
    gamemode.enable = true;
    gnupg.agent.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    localsend.enable = true;
    noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
    };
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
      package = pkgs.millennium-steam;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
