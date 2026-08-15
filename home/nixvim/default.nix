{ lib, pkgs, ... }:

let
  defaultGuifont = "CaskaydiaCove Nerd Font:h11";
in
{
  programs.nixvim = {
    imports = [
      (import ./mappings.nix { inherit defaultGuifont; })
      ./plugins.nix
    ];

    enable = true;

    nixpkgs.config.allowUnfree = true;

    clipboard.register = "unnamedplus";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      fillchars = "eob: ";
      guifont = defaultGuifont;
      updatetime = 500;
      # Neovide draws the message grid as a floating layer, and floating layers
      # composite their background over the root fill (SrcOver) rather than
      # replacing it (Src), so at 0.8 opacity that row lands at 0.96 and reads as
      # an opaque bar. It happens below the highlight layer, so no MsgArea change
      # reaches it. Reclaiming the row removes it outright; messages still appear
      # over the last line when there are any.
      cmdheight = 0;
    };

    globals = {
      neovide_cursor_animation_length = 0;
      # neovide_opacity would fade the text along with everything else. This
      # fades only the Normal background, matching what wezterm's
      # window_background_opacity does at the same 0.8.
      neovide_normal_opacity = 0.8;

      # wezterm's default window_padding is 1cell horizontally and 0.5cell
      # vertically. Measured off a screenshot, CaskaydiaCove at h11 gives a 9x18
      # px cell here, so both work out to 9px. neovide takes pixels and defaults
      # to 0, hence the explicit values — they only hold for this font at this
      # size, and would need remeasuring if either changes.
      neovide_padding_top = 9;
      neovide_padding_bottom = 9;
      neovide_padding_left = 9;
      neovide_padding_right = 9;
    };

    lsp = {
      servers = lib.mapAttrs (_: cfg: { packageFallback = true; } // cfg) {
        lua_ls.enable = true;
        nil_ls.enable = true;
        rust_analyzer.enable = true;
        vtsls = {
          enable = true;
          config = {
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
              "vue"
            ];
            settings.vtsls.tsserver.globalPlugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin";
                languages = [ "vue" ];
                enableForWorkspaceTypeScriptVersions = true;
              }
            ];
          };
        };
        vue_ls.enable = true;
      };
      inlayHints.enable = true;
    };

    diagnostic.settings = {
      virtual_lines = false;
      virtual_text = false;
      underline = true;
      update_in_insert = false;
      severity_sort = true;
      float = {
        border = "solid";
        source = true;
      };
    };

    # Theming comes from noctalia's neovim template, which generates
    # ~/.config/nvim/lua/matugen.lua. Its apply.sh can only install the plugin
    # into a lazy.nvim tree, so nixvim has to provide it here. No colorschemes.*
    # entry: matugen.setup() would just overwrite it.
    extraPlugins = [ pkgs.vimPlugins.base16-nvim ];

    autoCmd = [
      {
        event = "TermOpen";
        pattern = "*";
        command = "setlocal winfixheight nonumber norelativenumber";
      }
      {
        event = "CursorHold";
        pattern = "*";
        callback.__raw = ''
          function()
            vim.diagnostic.open_float(nil, { focus = false })
          end
        '';
      }
    ];

    extraConfigLua = ''
      local orig = vim.lsp.util.open_floating_preview
      vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "solid"
        return orig(contents, syntax, opts, ...)
      end
    ''
    + builtins.readFile ./theme.lua;
  };
}
