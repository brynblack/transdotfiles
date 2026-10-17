{ config, pkgs, ... }:

let
  toml = pkgs.formats.toml { };
in
{
  # Merged by noctalia over the state-dir settings.toml, which the shell
  # rewrites on every Settings change, so nothing here is lost to that.
  xdg.configFile."noctalia/config.toml".source = toml.generate "noctalia-config.toml" {
    theme.templates.user = {
      # Neovim colorscheme, loaded as `:colorscheme noctalia`. Neovim reloads it
      # on SIGUSR1 (see the Signal autocmd in home/nixvim).
      nvim = {
        input_path = "${./templates/nvim.lua}";
        output_path = "${config.xdg.configHome}/nvim/colors/noctalia.lua";
        post_hook = "pkill -USR1 -x nvim || true";
      };

      # Steam / Millennium "Material" theme (kuska1/Material-Theme).
      #
      # Replaces the community "steam" template, whose output_path targets only
      # the pre-3.0.0 Millennium theme dir. The theme's js/main/colors/matugen.js
      # polls steamloopback.host/skins/... first and falls back to
      # millennium.host/v1/themes/..., so both locations are written and Steam
      # repaints within ~1.5s of a palette change.
      steam = {
        input_path = "${./templates/steam.css}";
        output_path = [
          "${config.home.homeDirectory}/.steam/steam/millennium/themes/Material-Theme/css/main/colors/matugen.css"
          "${config.home.homeDirectory}/.steam/steam/steamui/skins/Material-Theme/css/main/colors/matugen.css"
        ];
      };
    };
  };
}
