{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      matching = "fuzzy";
    };
    style = ''
      * {
        all: unset;
        font-family: 'CaskaydiaCove Nerd Font';
        font-size: 16px;
      }
      #window {
        background-color: rgba(30, 46, 46, 0.1176);
        border: 1px solid #35363e;
        border-radius: 12px;
      }
      #outer-box {
        padding: 12px;
      }
    '';
  };
}
