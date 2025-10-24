{ config, pkgs, lib, ... }:

{
  boot = {
    kernelModules = [ "nvidia_uvm" ];
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd = {
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
      luks.devices = {
        "luks-f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4".device =
          "/dev/disk/by-uuid/f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4";
        games.device = "/dev/disk/by-uuid/2ec7ec00-8207-4a78-940d-de141353b4ce";
      };
      verbose = false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
