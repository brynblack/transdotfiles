{
  pkgs,
  ...
}:

{
  security.rtkit.enable = true;

  services = {
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # Never use Bluetooth handsfree (HSP/HFP): headphones stay on A2DP,
      # and apps opening a mic can't flip them into low-quality headset mode.
      wireplumber.extraConfig."51-bluetooth-no-handsfree" = {
        "monitor.bluez.properties" = {
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
          ];
          "bluez5.hfphsp-backend" = "none";
        };
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
    fwupd.enable = true;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
    uinput.enable = true;

    amdgpu.opencl.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
