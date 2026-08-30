{ pkgs, ... }:

let
  # vopono builds a network namespace holding a WireGuard tunnel and runs a
  # single application inside it, so the browser -- and nothing else -- goes
  # through the VPN. Proton's own split tunnelling would be the obvious
  # alternative, but it only ships in their official Ubuntu/Fedora/Arch builds,
  # not the nixpkgs repackage, and it still requires connecting in the GUI
  # first. Here, launching the browser is what brings the tunnel up.
  mullvad-browser-vpn = pkgs.writeShellApplication {
    name = "mullvad-browser-vpn";
    runtimeInputs = [ pkgs.vopono ];
    text = ''
      # vopono needs root to create the namespace. --askpass routes the prompt
      # through ksshaskpass so this still works from the app launcher, where
      # there is no terminal to type into. A NOPASSWD sudo rule would drop the
      # prompt entirely, but vopono runs arbitrary commands as root, so that
      # would leave a free root shell for anything that can exec it.
      export SUDO_ASKPASS="''${SUDO_ASKPASS:-${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass}"

      # Optional argument picks a different saved config, so a second server is
      # just another .conf next to the first: mullvad-browser-vpn sydney
      name="''${1:-proton}"
      config="''${VOPONO_WIREGUARD_CONFIG:-$HOME/.config/vopono/$name.conf}"

      if [ ! -f "$config" ]; then
        echo "No WireGuard config found at $config" >&2
        echo >&2
        echo "Download one from https://account.proton.me/vpn/WireGuard --" >&2
        echo "pick a server, set the platform to Linux -- then save it there," >&2
        echo "or point VOPONO_WIREGUARD_CONFIG at it." >&2
        exit 1
      fi

      # --disable-ipv6 is load-bearing: Proton's WireGuard configs carry no IPv6
      # route, so without it the browser would reach v6-capable sites over the
      # plain host connection and hand them the real address.
      # --firewall IpTables because nft is not in the system profile; letting
      # vopono autodetect risks it picking the backend that is not there.
      exec vopono --askpass exec \
        --custom "$config" \
        --protocol Wireguard \
        --firewall IpTables \
        --disable-ipv6 \
        "${pkgs.mullvad-browser}/bin/mullvad-browser"
    '';
  };

  # Deliberately replaces the upstream mullvad-browser.desktop rather than
  # sitting beside it: two near-identical "Mullvad Browser" entries in the
  # launcher is a footgun, since picking the wrong one browses with the real IP
  # while looking identical. The plain package is left out of systemPackages so
  # this is the only way to launch it, which is why the icon is referenced by
  # store path -- the package no longer contributes to the system icon theme.
  #
  # MimeType and %U are dropped on purpose. Registering this as an http handler
  # would let links from other applications open here, bleeding context from
  # identified browsing into the session that is supposed to be unlinkable.
  mullvad-browser-vpn-desktop = pkgs.makeDesktopItem {
    name = "mullvad-browser";
    desktopName = "Mullvad Browser";
    genericName = "Web Browser";
    comment = "Privacy-focused browser inside a Proton VPN network namespace";
    exec = "mullvad-browser-vpn";
    icon = "${pkgs.mullvad-browser}/share/icons/hicolor/128x128/apps/mullvad-browser.png";
    categories = [
      "Network"
      "WebBrowser"
      "Security"
    ];
  };
in
{
  environment.systemPackages = [
    mullvad-browser-vpn
    mullvad-browser-vpn-desktop
    # vopono shells out to wg and wg-quick through sudo, which resets PATH to
    # the system profile, so these have to be here rather than in the wrapper's
    # runtimeInputs.
    pkgs.wireguard-tools
  ];

  # vopono exec auto-detects /run/vopono.sock and forwards the privileged
  # namespace setup to this daemon, which is what removes the per-launch sudo
  # prompt. It falls back to sudo when the daemon is not running, so the wrapper
  # keeps --askpass and degrades to a password prompt rather than failing.
  #
  # Note this is comparable in power to a NOPASSWD sudo rule for vopono:
  # whatever can reach the socket can request a namespace, and --postup and
  # --predown run as root. That is the deliberate trade for not typing a
  # password to open a browser.
  systemd.services.vopono = {
    description = "vopono privileged daemon";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    # The daemon rather than the caller now runs ip/iptables/wg, and systemd
    # units do not inherit the system profile, so they go on the unit PATH.
    path = [
      pkgs.coreutils
      pkgs.iproute2
      pkgs.iptables
      # sysctl, which vopono calls to enable net.ipv4.ip_forward. This only
      # became necessary with the daemon: under the sudo fallback the call
      # inherited the system profile, which already has it.
      pkgs.procps
      pkgs.wireguard-tools
    ];
    serviceConfig = {
      ExecStart = "${pkgs.vopono}/bin/vopono daemon start";
      # vopono chmods its socket to 0777 on creation, which would let any local
      # account -- system service users included -- request a root-privileged
      # namespace. Narrowing it to wheel means the socket grants nothing its
      # users could not already reach through sudo; it only drops the password.
      # The poll is needed because Type=simple runs ExecStartPost as soon as the
      # daemon forks, which can be before it has bound the socket.
      ExecStartPost = pkgs.writeShellScript "vopono-socket-perms" ''
        for _ in $(seq 50); do
          [ -S /run/vopono.sock ] && break
          sleep 0.1
        done
        chgrp wheel /run/vopono.sock
        chmod 0660 /run/vopono.sock
      '';
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
