{
  config,
  ...
}:

{
  # Holds the CIFS credentials file and the games LUKS keyfile, kept out of the
  # repo and readable by root only.
  systemd.tmpfiles.rules = [ "d /var/lib/secrets 0700 root root -" ];

  # The games drive is unlocked in stage 2 with a keyfile on root, so it is
  # exactly as protected as root is. Unlocked in the initrd with nofail, nothing
  # ordered it before switch-root, which could start mid-unlock. The drive keeps
  # its own passphrase keyslot, so losing root costs the keyfile, not the data.
  #
  # headless=yes: if the keyfile is missing, fail rather than wait on a
  # password prompt nobody sees behind the greeter. nofail plus /srv/games'
  # nofail lets boot carry on without it either way.
  environment.etc.crypttab.text = ''
    games /dev/disk/by-uuid/240c3383-ee98-4363-b2f2-0e0c03706b04 /var/lib/secrets/games.key discard,headless=yes,nofail
  '';

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8c4a536b-109e-471d-bbfe-2ff2ae3b9512";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C63C-E1AC";
      fsType = "vfat";
      # Root only: the ESP holds systemd-boot's random seed.
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/srv/games" = {
      device = "/dev/mapper/games";
      fsType = "ext4";
      options = [
        "nofail"
        "x-systemd.device-timeout=10s"
      ];
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
          "${automount_opts},credentials=/var/lib/secrets/smb-vault,uid=${toString config.users.users.brynleyl.uid},gid=${toString config.users.groups.users.gid}"
          "vers=3.1.1,seal"
          "_netdev"
        ];
    };
  };
}
