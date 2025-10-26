{
  programs.wofi = {
    enable = true;
    style = ./wofi.css;
    settings = {
      show = "drun";
      matching = "multi-contains";
      insensitive = true;
      sort_order = "alphabetical";
      allow_images = true;
      prompt = "search";
      no_actions = true;
    };
  };
}
