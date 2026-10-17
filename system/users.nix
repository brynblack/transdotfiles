{ pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users.brynleyl = {
      isNormalUser = true;
      uid = 1000;
      description = "Brynley";
      extraGroups = [
        "gamemode"
        "networkmanager"
        "uinput"
        "wheel"
      ];
    };
  };
}
