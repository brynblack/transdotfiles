{
  networking = {
    hostName = "nixos";
    hostId = "0f2bfeab";
    # nameservers = [
    #   "9.9.9.9#dns.quad9.net"
    #   "149.112.112.112#dns.quad9.net"
    # ];
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.enable = true;
  };

  services = {
    resolved = {
      enable = true;
      settings.Resolve = {
        FallbackDNS = [ "" ];
        # DNSSEC = true;
        # DNSOverTLS = true;
        DNSSEC = false;
        DNSOverTLS = false;
      };
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
