{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      matching = "multi-contains";
      insensitive = true;
      sort_order = "alphabetical";
      allow_images = true;
      prompt = "search";
      no_actions = true;
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
      #input {
        padding: 12px;
        border: 1px solid #35363e;
        border-radius: 12px;
        margin-bottom: 12px;
      }
      #input > * {
        margin-right: 8px;
      }
      #entry {
        padding: 12px;
        border-radius: 12px;
      }
      #entry:selected {
        background-color: rgba(30, 46, 46, 1.0);
      }
      #img {
        margin-right: 8px;
      }
    '';
  };
}
