{
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    users.brynleyl = {
      isNormalUser = true;
      description = "Brynley";
      extraGroups = [
        "gamemode"
        "input"
        "networkmanager"
        "uinput"
        "wheel"
      ];
    };
  };
}
