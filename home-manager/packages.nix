{ pkgs, inputs, ... }:

with pkgs; {
  home.packages = [
    home-manager

    nil # nix lsp
    lua-language-server # lua lsp

    ripgrep # nvim tool
    openal # openrgb plugin support
    icu
    icu.dev
    gcc # compiler
    rustup # rust support
    nixfmt-classic # nix formatter
    wl-clipboard # clipboard support

    # upscayl # Image upscaling
    # ukmm # BOTW
    # cemu # BOTW

    btop # Task manager
    cava # Audio visualizer
    kde-rounded-corners # KDE theming
    adw-gtk3 # GTK theming
    dwt1-shell-color-scripts # Fancy terminal colors
    eza # ls
    git # Git
    neovim # Code editor (only used for vscodium integration)
    (vscode-with-extensions.override {
      vscodeExtensions = ((with vscode-extensions; [
        continue.continue
        catppuccin.catppuccin-vsc
        asvetliakov.vscode-neovim
        jnoortheen.nix-ide
        github.vscode-github-actions
      ]));
    })
    prismlauncher # Minecraft
    osu-lazer-bin # osu!
    vesktop # Discord
    krita # Drawing
    spotify # Music
    kdePackages.kdenlive # Video editor
    audacity # Audio editor
    (blender.override { cudaSupport = true; })
    wlx-overlay-s # VR desktop manager
    inputs.zen-browser.packages."${system}".default # Browser
  ];

  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);
}
