{ pkgs, ... }:

let
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = ./.;
    dontUnpack = true;
    installPhase = ''
      cp $src/galaxy.png $out
    '';
  };
in {
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
    };
    displayManager.sddm = {
      enable = true;
      theme = "breeze";
    };
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = ${background-package}
    '')
  ];
}
