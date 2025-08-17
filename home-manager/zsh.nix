{
  programs = {
    zsh = {
      enable = true;
      initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
        export EDITOR=nvim
        alias ls='eza -lh --icons=always --sort=type'
        bindkey '^E' autosuggest-accept
        colorscript -e zwaves
      '';
    };

    fzf.enable = true;
  };
}
