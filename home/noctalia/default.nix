{
  config,
  osConfig,
  pkgs,
  ...
}:

let
  toml = pkgs.formats.toml { };

  openrgb-load-profile = pkgs.writers.writePython3Bin "openrgb-load-profile" {
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./openrgb-load-profile.py);
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

      # kitty, from noctalia's own kitty template. Its builtin version's hook
      # appends an include to kitty.conf, which fails on the read-only
      # /nix/store symlink, so home/kitty.nix includes the output itself.
      kitty = {
        input_path = "${osConfig.programs.noctalia.package}/share/noctalia/assets/templates/kitty/kitty.conf";
        output_path = "${config.xdg.configHome}/kitty/themes/noctalia.conf";
        post_hook = "pkill -USR1 -x kitty || true";
      };

      # tmux status bar, borders and prompts, sourced from tmux.conf (see
      # home/tmux.nix). Re-sourcing it recolours every running session.
      tmux = {
        input_path = "${./templates/tmux.conf}";
        output_path = "${config.xdg.configHome}/tmux/noctalia.conf";
        post_hook = "tmux source-file ${config.xdg.configHome}/tmux/noctalia.conf 2>/dev/null || true";
      };

      # Claude Code custom theme, selected in /theme as "Noctalia". Claude Code
      # watches its themes dir and reloads on change, so no hook is needed;
      # only the very first write needs a restart, as the dir won't exist yet.
      claude = {
        input_path = "${./templates/claude.json}";
        output_path = "${config.home.sessionVariables.CLAUDE_CONFIG_DIR}/themes/noctalia.json";
      };

      # OpenRGB "Default" profile: the Effects plugin's NoiseMap effect, in
      # the primary colour at full saturation, as pastel tones wash out to
      # white on LEDs. Built from the profile saved by the GUI, so re-export
      # it after changing the effect or devices there, and put the colours
      # back as "#rrggbb" placeholders.
      #
      # The hook uploads it to the system openrgb service over the SDK and
      # loads it, which converts the hex colours and reapplies the effect
      # live. Being the service's startup/resume profile, it also persists.
      openrgb = {
        input_path = "${./templates/openrgb.json}";
        output_path = "${config.xdg.configHome}/OpenRGB/noctalia.json";
        post_hook = "${openrgb-load-profile}/bin/openrgb-load-profile ${config.xdg.configHome}/OpenRGB/noctalia.json";
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
