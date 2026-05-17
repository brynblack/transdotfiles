{
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    users.brynleyl = {
      isNormalUser = true;
      description = "Brynley";
      extraGroups = [
        "input"
        "networkmanager"
        "uinput"
        "wheel"
      ];
    };
  };
}
