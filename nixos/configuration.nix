{
  imports = [
    ./audio.nix
    ./boot.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./users.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    GTK_THEME = "adw-gtk3-dark";
  };

  services.upower.enable = true;

  system.stateVersion = "25.05";
}
