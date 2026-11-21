# Stellaris statically links SDL2 but honours SDL_DYNAMIC_API, so it can be
# pointed at a patched SDL2 whose keycodes follow physical key position. This
# keeps the default hotkeys on QWERTY positions while typing Colemak.
#
# Steam launch options for Stellaris (native build):
#   SDL_DYNAMIC_API=$HOME/.local/lib/sdl2-physical-keys/libSDL2-2.0.so.0 %command%
{ pkgs, ... }:

let
  sdl2-physical-keys = pkgs.callPackage ../pkgs/sdl2-physical-keys { };
in
{
  home.file.".local/lib/sdl2-physical-keys/libSDL2-2.0.so.0".source =
    "${sdl2-physical-keys}/lib/libSDL2-2.0.so.0";
}
