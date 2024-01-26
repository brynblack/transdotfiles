{ config, pkgs, ... }: {

  imports = [
    
  ];

  environment.systemPackages = with pkgs; [
    git
    helix
    starship
  ];

  programs = {
    zsh.enable = true;
  };
}
