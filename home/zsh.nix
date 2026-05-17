{ config, ... }:

{
  programs = {
    fzf.enable = true;
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
        export EDITOR=nvim
        alias ls='eza -lh --icons=always --sort=type'
        bindkey '^E' autosuggest-accept
        colorscript -e zwaves
        nv() { neovide "$@" &>/dev/null & disown }
      '';
    };
  };
}
