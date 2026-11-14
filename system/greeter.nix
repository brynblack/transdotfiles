{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  # Phone-style first unlock: the LUKS passphrase typed at boot is the
  # authentication, so greetd logs straight in once per boot. initial_session
  # only runs when greetd first starts; logging out falls back to the greeter,
  # and locking still uses Noctalia's lock screen.
  services.greetd.settings.initial_session = {
    user = "brynleyl";
    # Same Exec as the "Hyprland (uwsm-managed)" session the greeter launches.
    command = "${config.programs.uwsm.package}/bin/uwsm start -e -D Hyprland hyprland.desktop";
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "Hyprland (uwsm-managed)";
      user.default = "brynleyl";
      keyboard = {
        layout = "us";
        variant = "colemak";
      };
      # Keep in sync with the hl.monitor() rules in home/hyprland/hyprland.lua.
      output = {
        name = "DP-1";
        layout = "DP-1:0,0; HDMI-A-1:1920,-350";
        transforms = "DP-1:normal; HDMI-A-1:90";
      };
      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
      appearance.scheme = "Synced";
    };
  };
}
