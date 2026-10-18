{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # A fresh random key every boot: nothing to unlock, no keyslots to attack,
  # and last boot's swap is unreadable once powered off. Rules out hibernation,
  # which 8.8G of swap against 31G of RAM couldn't do reliably anyway.
  # By PARTUUID because the partition is reformatted as plain dm-crypt on each
  # boot, so it has no stable filesystem or LUKS UUID.
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/1b616b4f-3d26-4d07-af0e-d51cf50811ac";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

  boot = {
    kernelModules = [
      "kvm-amd"
      "ntsync"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      # lanzaboote copies this into loader.conf. Root unlocks from the TPM with
      # no passphrase, so a kernel command line edited at the boot menu (say,
      # to get a shell) would run with the disk already open.
      systemd-boot.editor = false;
    };
    plymouth.enable = true;
    initrd = {
      kernelModules = [
        "amdgpu"
      ];
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
        "luks-c0129f7e-299d-40ca-834d-60f1aff9e11b" = {
          device = "/dev/disk/by-uuid/c0129f7e-299d-40ca-834d-60f1aff9e11b";
          allowDiscards = true;
        };
        # games is unlocked in stage 2 instead; see system/filesystems.nix.
      };
      verbose = false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
