{
  config,
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
      # allowDiscards only lets dm-crypt pass discards through; swapon has to be
      # asked to issue them.
      discardPolicy = "both";
    }
  ];

  # The kernel still offers hibernation as long as swap exists, and nothing
  # written to this swap survives a reboot: a hibernate would look like it
  # worked, then cold-boot and lose every open session.
  systemd.sleep.settings.Sleep = {
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
  };

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
    plymouth = {
      enable = true;
      theme = "bgrt-nokeymap";
      # bgrt with its keyboard layout indicator removed. two-step has no option
      # for it, but skips the indicator when ImageDir has no keyboard.png, so
      # point it at a copy of spinner's images without one.
      themePackages = [
        (pkgs.runCommand "plymouth-bgrt-nokeymap" { } ''
          themes=${pkgs.plymouth}/share/plymouth/themes
          dir=$out/share/plymouth/themes/bgrt-nokeymap
          mkdir -p $dir
          cp $themes/spinner/*.png $dir
          rm $dir/keyboard.png $dir/keymap-render.png
          # The NixOS module only adds the logo to the stock spinner dir.
          cp ${config.boot.plymouth.logo} $dir/watermark.png
          sed -e "s,^ImageDir=.*,ImageDir=$dir," \
            -e "s,^Name=.*,Name=BGRT (no keymap)," \
            -e "/^Name\[/d" \
            $themes/bgrt/bgrt.plymouth > $dir/bgrt-nokeymap.plymouth
        '')
      ];
    };
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
      systemd.tpm2.enable = true;
      luks.devices = {
        "luks-c0129f7e-299d-40ca-834d-60f1aff9e11b" = {
          device = "/dev/disk/by-uuid/c0129f7e-299d-40ca-834d-60f1aff9e11b";
          allowDiscards = true;
        };
        # games is unlocked in stage 2 instead; see system/filesystems.nix.
      };
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
