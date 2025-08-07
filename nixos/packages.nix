{ pkgs, inputs, ... }:

with pkgs; {
  environment.systemPackages = [
    home-manager # self-explanatory

    ## LSP/Formatting

    nil # nix lsp
    lua-language-server # lua lsp
    nixfmt-classic # nix formatter

    ## Development/CLI tools

    openal # openrgb plugin support
    icu # this is probably important
    icu.dev # this too
    gcc # compiler
    rustup # rust support
    wl-clipboard # clipboard support
    unzip # unzipping archives
    wget # downloading files
    npm-check-updates # bulk-updating npm packages
    cava # audio visualizer
    eza # ls
    git # git
    pfetch # neofetch
    grim
    slurp
    ripgrep
    libnotify
    ffmpeg
    playerctl
    hyprpicker # color picker
    alsa-utils # alsa controls
    usbutils # lsusb, etc
    yubikey-manager # yubikey manager
    onlykey-cli # onlykey manager

    ## Theming
    dwt1-shell-color-scripts # fancy terminal colors
    capitaine-cursors

    ## Disabled packages
    # ukmm # BOTW
    # cemu # BOTW
    # darktable # RAW editing

    pavucontrol # audio manager
    loupe # image viewer
    nautilus # file manager
    upscayl # image upscaling
    neovim # code editor
    prismlauncher # minecraft
    osu-lazer-bin # osu!
    vesktop # discord
    krita # drawing
    spotify # music
    kdePackages.kdenlive # video editor
    audacity # audio editor
    (blender.override { cudaSupport = true; })
    wlx-overlay-s # VR desktop manager
    inputs.zen-browser.packages."${system}".default # browser
    tor-browser # anonymous browsing
  ];

  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);
}
