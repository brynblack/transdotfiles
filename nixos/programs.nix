{ inputs, pkgs, ... }:

{  
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  programs.kdeconnect.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.bash.enableCompletion = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.mtr.enable = true;
  programs.light.enable = true;
  programs.adb.enable = true;
  programs.bcc.enable = true;
  programs.fuse = {
    userAllowOther = true;
  };
  programs.seahorse.enable = false;
  programs.starship.enable = true;
}
