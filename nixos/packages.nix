{ pkgs, inputs, ... }:

with pkgs; {
  environment.systemPackages = [
    home-manager # self-explanatory

    nil # nix lsp
    lua-language-server # lua lsp
    nixfmt-classic # nix formatter

    openal # openrgb plugin support
    icu # this is probably important
    icu.dev # this too
    gcc # compiler
    rustup # rust support
    wl-clipboard # clipboard support
    unzip # unzipping archives
    wget # downloading files
    npm-check-updates # bulk-updating npm packages

    # upscayl # image upscaling
    # ukmm # BOTW
    # cemu # BOTW

    btop # task manager
    cava # audio visualizer
    kde-rounded-corners # KDE theming
    adw-gtk3 # GTK theming
    dwt1-shell-color-scripts # fancy terminal colors
    eza # ls
    git # git
    neovim # code editor (only used for vscodium integration)
    (vscode-with-extensions.override {
      vscodeExtensions = ((with vscode-extensions; [
        continue.continue
        catppuccin.catppuccin-vsc
        asvetliakov.vscode-neovim
        jnoortheen.nix-ide
        github.vscode-github-actions
        vue.volar
        vscjava.vscode-gradle
        vscjava.vscode-java-pack
        redhat.java
        leonardssh.vscord
      ]));
    })
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
  ];

  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);
}
