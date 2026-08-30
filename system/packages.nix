{ pkgs, ... }:

with pkgs;
{
  environment.systemPackages = [
    adw-gtk3 # theming
    btop # system monitor
    capitaine-cursors # cursor package
    claude-code # ai agent
    darktable # raw editing
    ddcutil # brightness control
    dwt1-shell-color-scripts # shell eye candy
    element-desktop # private messaging
    enblend-enfuse # darktable plugin
    eza # ls replacement
    fd # telescope.nvim find_files
    feishin # music
    git # git
    hugin # darktable plugin
    hyprpicker # color picker
    hyprshot # screenshot utility
    kdePackages.breeze # theming
    kdePackages.breeze-icons # theming
    kdePackages.qt6ct # qt5/qt6 customiser
    loupe # image viewer
    mpv # video player
    nautilus # file manager
    neovide # code editor
    nh # nix helper
    pfetch # neofetch replacement
    prismlauncher # minecraft
    proton-pass # password manager
    proton-vpn # vpn
    protonplus # proton tools
    ripgrep # telescope.nvim live_grep
    tor-browser # anonymous browsing
    vesktop # discord
    via # keyboard customiser
    vintagestory # vintage story
    vopono # per-app vpn namespaces
    wayvr # vr desktop manager
    wl-clipboard # clipboard support
  ];

  fonts.packages = [
    noto-fonts-cjk-sans
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
