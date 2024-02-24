{ username, ... }:

{
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    enforceIdUniqueness = true;
    mutableUsers = true;
    users.${username} = {
      description = "Brynley Llewellyn-Roux";
      isNormalUser = true;
      initialPassword = username;
      group = "operators";
      extraGroups = [
        "wheel"
        "users"
        "networkmanager"
        "docker"
        "adbusers"
        "plugdev"
        "vboxusers"
        "video"
        "audio"
      ];
    };
    groups = {
      operators = {
        gid = 1000;
      };
      plugdev = {
        gid = 1001;
      };
    };
  };

}
