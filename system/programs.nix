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
    gamemode = {
      enable = true;
      settings = {
        general.renice = 10;
        # Pin the GPU to its top clock state while a game runs, so it stops
        # downclocking between frames when the CPU is the bottleneck.
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
    gnupg.agent.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    localsend.enable = true;
    nh = {
      enable = true;
      flake = "/home/brynleyl/.config/nixos";
      clean.enable = true;
    };
    noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
    };
    ssh = {
      askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      # Defaults to services.xserver.enable, which this Wayland-only setup leaves off.
      enableAskPassword = true;
    };
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
      # home-manager's zsh already runs compinit; running it here too doubles
      # the work on every shell start.
      enableGlobalCompInit = false;
    };
  };
}
