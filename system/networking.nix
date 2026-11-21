{
  networking = {
    hostName = "nixos";
    # DNS servers come from DHCP.
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      # Fail rather than fall back to resolved's built-in public servers.
      FallbackDNS = [ "" ];
      # Validation is left to the upstream resolver.
      DNSSEC = false;
    };
  };
}
