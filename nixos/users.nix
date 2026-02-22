{
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    users.brynleyl = {
      isNormalUser = true;
      description = "Brynley";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "uinput"
      ];
    };
  };
}
