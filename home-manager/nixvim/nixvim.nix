{
  programs.nixvim = {
    imports = [
      ./mappings.nix
      ./plugins.nix
    ];

    enable = true;

    clipboard.register = "unnamedplus";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      fillchars = "eob: ";
      guifont = "CaskaydiaCove Nerd Font:h12";
      updatetime = 500;
    };

    globals = {
      neovide_cursor_animation_length = 0;
    };

    lsp = {
      servers = {
        nil_ls.enable = true;
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

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

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
