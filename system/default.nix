{
  inputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./greeter.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./users.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [ inputs.millennium.overlays.default ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_LOGGING_RULES = "qt.qpa.services.warning=false";
    # Kept here rather than relying on home.pointerCursor: UWSM builds the
    # session environment without sourcing home-manager's session variables.
    XCURSOR_SIZE = "24";
  };

  services = {
    accounts-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    wivrn = {
      enable = true;
      autoStart = true;
      highPriority = true;
      openFirewall = true;
      steam.importOXRRuntimes = true;
    };
  };

  # Auto-Sync fires this action on every wallpaper, colour or theme-mode change,
  # and the shipped policy demands auth_admin even for an active local session.
  # The helper only ever installs a validated staging directory into
  # /var/lib/noctalia-greeter, so dropping the prompt for this one action is
  # low-risk. It still only applies to wheel in the active local session, not
  # to remote or background sessions.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id === "org.noctalia.greeter.apply-appearance" &&
        subject.isInGroup("wheel") &&
        subject.local &&
        subject.active
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  system.stateVersion = "26.05";
}
