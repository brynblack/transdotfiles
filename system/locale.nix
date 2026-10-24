{
  # Generate the console keymap from XKB rather than using kbd's colemak map:
  # that one sends ^H for Caps, which Plymouth (reading the tty) takes as a
  # character, whereas ckbcomp maps BackSpace to DEL like the real Backspace key.
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  time.timeZone = "Australia/Sydney";

  i18n.defaultLocale = "en_AU.UTF-8";
}
