{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.hostId = "0f2bfeab";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
