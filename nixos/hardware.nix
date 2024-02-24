{ pkgs, ... }:

{
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.vaapiIntel
        pkgs.libvdpau-va-gl
        pkgs.intel-media-driver
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
