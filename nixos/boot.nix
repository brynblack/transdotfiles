{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = false;
      };
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelParams = [
      "zfs_force=1"
    ];

    hardwareScan = true;

    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
        "uas"
      ];
    };

    kernelModules = [ "kvm-intel" "coretemp" "iwlwifi" ];
    kernel.sysctl = {
      "kernel.task_delayacct" = 1;
    };

    supportedFilesystems = [ "zfs" "nfs" "exfat" ];

    tmp.cleanOnBoot = true;

    runSize = "50%";
    devShmSize = "50%";
    devSize = "5%";

    readOnlyNixStore = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  powerManagement.cpuFreqGovernor = "powersave";

  fileSystems = {
    "/" = {
      device = "rpool";
      fsType = "zfs";
    };
    "/tmp" = {
      device = "rpool/tmp";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-id/-part1";
      fsType = "vfat";
    };
  };

  swapDevices = builtins.map (p: { device = p; } ) [
    "/dev/disk/by-id/-part2"
  ];
}
