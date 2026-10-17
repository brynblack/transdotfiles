{
  networking = {
    hostName = "nixos";
    # The #name suffix is the hostname resolved checks each server's TLS
    # certificate against.
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services = {
    resolved = {
      enable = true;
      settings.Resolve = {
        # Route every lookup to the servers above. Without this, resolved also
        # queries whatever DNS each link got from DHCP, in parallel.
        Domains = [ "~." ];
        FallbackDNS = [ "" ];
        # Validates whenever the upstream serves DNSSEC records, which
        # Cloudflare always does. Over an authenticated DoT channel nobody can
        # strip them to force the downgrade, and unlike strict mode it doesn't
        # hard-fail domains with broken signatures.
        DNSSEC = "allow-downgrade";
        DNSOverTLS = true;
      };
    };
  };
}
