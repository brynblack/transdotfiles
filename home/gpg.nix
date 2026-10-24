{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  # Managed here rather than by the NixOS gnupg.agent module: its sockets sit
  # at a fixed path, while a non-default homedir moves gpg's expected socket
  # under a hashed d.<hash> directory, which this module accounts for.
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
