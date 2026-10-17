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
      jack.enable = true;
      pulse.enable = true;
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
