let
  commentLineKey = "<leader>/";
  commentBlockKey = "<leader><c-/>";
in
{
  plugins = {
    bufdelete.enable = true;
    bufferline = {
      enable = true;
      settings = {
        options = {
          close_command.__raw = ''
            function(bufnum)
              require('bufdelete').bufdelete(bufnum, true)
            end
          '';
          offsets = [
            {
              filetype = "neo-tree";
              highlight = "Directory";
            }
          ];
        };
      };
    };
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<s-tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<c-space>" = "cmp.mapping.complete()";
        };
      };
    };
    comment = {
      enable = true;
      settings = {
        toggler = {
          line = commentLineKey;
          block = commentBlockKey;
        };
        opleader = {
          line = commentLineKey;
          block = commentBlockKey;
        };
      };
    };
    gitsigns.enable = true;
    highlight-colors = {
      enable = true;
      settings = {
        render = "virtual";
        virtual_symbol = "■";
      };
    };
    indent-blankline = {
      enable = true;
      settings = {
        indent.highlight = "LineNr";
        scope.highlight = "Comment";
      };
    };
    lspconfig.enable = true;
    lualine.enable = true;
    neo-tree = {
      enable = true;
      settings.window.mappings = {
        "n".__raw = "function() vim.cmd('normal! h') end";
        "e".__raw = "function() vim.cmd('normal! j') end";
        "i".__raw = "function() vim.cmd('normal! k') end";
        "o".__raw = "function() vim.cmd('normal! l') end";
      };
    };
    nvim-autopairs.enable = true;
    scope.enable = true;
    telescope = {
      enable = true;
      enabledExtensions = [ "scope" ];
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fw" = "live_grep";
        "<leader>fb" = "buffers";
      };
      settings = {
        defaults = {
          sorting_strategy = "ascending";
          layout_config.prompt_position = "top";
          borderchars = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };
      };
    };
    treesitter.enable = true;
    web-devicons.enable = true;
  };
}
