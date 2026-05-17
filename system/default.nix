{
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./graphics.nix
    ./hardware.nix
    ./keyboard.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./users.nix
    inputs.xremap.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_LOGGING_RULES = "qt.qpa.services.warning=false";
    SSH_ASKPASS_REQUIRE = "force";
    XCURSOR_SIZE = "24";
  };

  services = {
    upower.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    accounts-daemon.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  system.stateVersion = "26.05";
}
