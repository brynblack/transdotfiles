{ hostname, ... }:

{
  networking = rec {
    hostName = hostname;
    hostId = builtins.substring 0 8 (builtins.hashString "sha256" hostName);
    enableIPv6 = true;
    useNetworkd = false;
    networkmanager = {
      enable = true;
      insertNameservers = [ "9.9.9.9" ];
    };
    firewall = {
      enable = true;
      allowPing = true;
      pingLimit = "--limit 3/second --limit-burst 5";
      allowedTCPPorts = [
        22   # ssh
      ];
      allowedUDPPorts = [
        22 # ssh
      ];
      checkReversePath = "loose";
      rejectPackets = false;
      logRefusedConnections = true;
      logRefusedPackets = false;
      logRefusedUnicastsOnly = false;
    };
  };
}
