{
  programs = {
    zsh = {
      enable = true;
      initContent = ''
        export EDITOR=nvim
        alias ls='eza -lh --icons=always --sort=type'
        bindkey '^E' autosuggest-accept
        colorscript -e zwaves
      '';
    };

    fzf.enable = true;
  };
}
