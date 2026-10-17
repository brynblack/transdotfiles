{ config, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs = {
    fzf.enable = true;
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      shellAliases.ls = "eza -lh --icons=always --sort=type";
      initContent = ''
        bindkey '^E' autosuggest-accept
        colorscript -e zwaves
        nv() { neovide "$@" &>/dev/null & disown }
      '';
    };
  };
}
