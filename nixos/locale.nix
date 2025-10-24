{ pkgs, ... }:

{
  console.keyMap = "colemak";
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  time.timeZone = "Australia/Sydney";

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
    # inputMethod = {
    #   type = "fcitx5";
    #   enable = true;
    #   fcitx5 = {
    #     waylandFrontend = true;
    #     addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
    #   };
    # };
  };
}
