{
  programs.bat = {
    enable = true;
    # Builtin theme that emits terminal palette indices instead of truecolor,
    # so output (even already on screen) recolours with kitty's noctalia
    # palette on a wallpaper change
    config.theme = "base16";
  };
}
