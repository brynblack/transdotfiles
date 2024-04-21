{
  programs.zsh = {
    enable = true;
    initExtra = ''
      export EDITOR=hx

      alias ls='eza -lh --icons=always'
      alias lsa='ls -a'
      alias shx='sudo -E hx'

      colorscript --random
    '';
  };
}
