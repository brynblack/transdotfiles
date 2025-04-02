{
  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        export EDITOR=nvim
        alias ls='eza -lh --icons=always --sort=type'
        colorscript -e zwaves
      '';
    };

    fzf.enable = true;
  };
}
