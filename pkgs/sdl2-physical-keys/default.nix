# Upstream SDL2 (not sdl2-compat) patched so keycodes follow physical key
# position instead of the active keyboard layout. Meant to be injected into
# games that statically link SDL2 via SDL_DYNAMIC_API (e.g. native Stellaris),
# so their hotkeys behave as on US-QWERTY regardless of layout (Colemak).
{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  libdecor,
  libx11,
  libxcb,
  libxext,
  libxcursor,
  libxi,
  libxrandr,
  libxfixes,
  libxscrnsaver,
  libxxf86vm,
  libGL,
  vulkan-loader,
  alsa-lib,
  libpulseaudio,
  pipewire,
  dbus,
  udev,
}:

let
  # SDL dlopen()s these at runtime by soname; bake them into the RPATH so the
  # library works no matter what environment the game runs in.
  dlopenLibs = [
    wayland
    libxkbcommon
    libdecor
    libx11
    libxext
    libxcursor
    libxi
    libxrandr
    libxfixes
    libxscrnsaver
    libxxf86vm
    libGL
    vulkan-loader
    alsa-lib
    libpulseaudio
    pipewire
    dbus
    udev
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-physical-keys";
  version = "2.32.10";

  src = fetchurl {
    url = "https://github.com/libsdl-org/SDL/releases/download/release-${finalAttrs.version}/SDL2-${finalAttrs.version}.tar.gz";
    hash = "sha256-X1mTxTDwhFNcZaaHnpsmrUQRabPiXXidgyhwQKnKUWU=";
  };

  patches = [ ./physical-keycodes.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = dlopenLibs ++ [
    wayland-protocols
    libxcb
  ];

  cmakeFlags = [
    (lib.cmakeBool "SDL_STATIC" false)
    (lib.cmakeBool "SDL_TEST" false)
    (lib.cmakeBool "SDL_KMSDRM" false)
    (lib.cmakeBool "SDL_WAYLAND" true)
    (lib.cmakeBool "SDL_WAYLAND_LIBDECOR" true)
    (lib.cmakeBool "SDL_X11" true)
    (lib.cmakeBool "SDL_PIPEWIRE" true)
    (lib.cmakeBool "SDL_PULSEAUDIO" true)
    (lib.cmakeBool "SDL_ALSA" true)
  ];

  # Only the shared library is needed; SDL2's pkg-config/cmake files have
  # malformed absolute paths that nixpkgs' checks reject.
  postInstall = ''
    rm -rf $out/bin $out/include $out/share $out/lib/pkgconfig $out/lib/cmake $out/lib/*.a
  '';

  postFixup = ''
    for lib in $out/lib/libSDL2*.so*; do
      if [ -f "$lib" ] && [ ! -L "$lib" ]; then
        patchelf --add-rpath ${lib.makeLibraryPath dlopenLibs} "$lib"
      fi
    done
  '';

  meta = {
    description = "SDL2 with keycodes mapped by physical key position (layout-independent hotkeys)";
    homepage = "https://libsdl.org";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
  };
})
