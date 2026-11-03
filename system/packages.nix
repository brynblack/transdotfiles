{ pkgs, ... }:

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
    protonplus # proton tools
    ripgrep # grep replacement
    vesktop # discord
    vintagestory # vintage story
    wayvr # vr desktop manager
    wl-clipboard # clipboard support
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # kitty, noctalia
    nerd-fonts.symbols-only # glyph fallback for other fonts
    noto-fonts-cjk-sans
  ];
}
