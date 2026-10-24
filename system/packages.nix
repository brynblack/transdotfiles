{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3 # theming
    btop # system monitor
    claude-code # ai agent
    darktable # raw editing
    ddcutil # brightness control
    dwt1-shell-color-scripts # shell eye candy
    element-desktop # private messaging
    enblend-enfuse # darktable plugin
    eza # ls replacement
    fd # find replacement
    feishin # music
    hugin # darktable plugin
    hyprpicker # color picker
    hyprshot # screenshot utility
    kdePackages.breeze # theming
    kdePackages.breeze-icons # theming
    librewolf # browser
    loupe # image viewer
    mpv # video player
    nautilus # file manager
    pfetch # neofetch replacement
    prismlauncher # minecraft
    # password manager
    (proton-pass.overrideAttrs (old: {
      # Stop the app writing native messaging manifests into every browser's
      # config dir on startup (~/.mozilla, ~/.config/chromium, ...). They're
      # only needed for unlocking the browser extension via the desktop app.
      preInstall =
        lib.replaceStrings
          [ "asar pack" ]
          [
            ''
              substituteInPlace tmp/.webpack/main/index.js \
                --replace-fail "await (native_namespaceFn().napi_native_messaging).install(config.hostLocation);" ""
              asar pack''
          ]
          old.preInstall;
    }))
    proton-vpn # vpn
    protonplus # proton tools
    ripgrep # grep replacement
    tor-browser # anonymous browsing
    vesktop # discord
    vintagestory # vintage story
    wayvr # vr desktop manager
    wl-clipboard # clipboard support
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove # kitty, noctalia
    nerd-fonts.symbols-only # glyph fallback for other fonts
    noto-fonts-cjk-sans
  ];
}
