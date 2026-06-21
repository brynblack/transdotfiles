{
  config,
  ...
}:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8c4a536b-109e-471d-bbfe-2ff2ae3b9512";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C63C-E1AC";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/srv/games" = {
      device = "/dev/mapper/games";
      fsType = "ext4";
    };
    "/mnt/vault" = {
      device = "//10.0.0.2/vault";
      fsType = "cifs";
      options =
        let
          automount_opts =
            "x-systemd.automount,noauto,"
            + "x-systemd.idle-timeout=60,"
            + "x-systemd.device-timeout=5s,"
            + "x-systemd.mount-timeout=5s";
        in
        [
          "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${toString config.users.users.brynleyl.uid},gid=${toString config.users.groups.users.gid}"
          "uid=1000"
          "gid=100"
          ",vers=3.1.1,seal"
          ",_netdev"
        ];
    };
  };
}
