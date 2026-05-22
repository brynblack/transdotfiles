{ lib, pkgs, ... }:

let
  defaultGuifont = "CaskaydiaCove Nerd Font:h12";
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
    };

    globals = {
      neovide_cursor_animation_length = 0;
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

    colorschemes.ayu.enable = true;

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
    '';
  };
}
