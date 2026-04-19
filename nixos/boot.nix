{
  pkgs,
  ...
}:

{
  swapDevices = [ { device = "/dev/disk/by-uuid/acf90d0f-99c5-4034-a52e-7c870c333bdd"; } ];

  boot = {
    kernelModules = [
      "kvm-amd"
      "nvidia_uvm"
    ];
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
      luks.devices = {
        "luks-f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4".device =
          "/dev/disk/by-uuid/f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4";
        "luks-c0129f7e-299d-40ca-834d-60f1aff9e11b".device =
          "/dev/disk/by-uuid/c0129f7e-299d-40ca-834d-60f1aff9e11b";
        games.device = "/dev/disk/by-uuid/41bee30a-6023-4b2f-b235-99348e1914d0";
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
