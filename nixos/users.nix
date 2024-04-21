{
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    users.brynleyl = {
      isNormalUser = true;
      description = "Brynley Llewellyn-Roux";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
}
