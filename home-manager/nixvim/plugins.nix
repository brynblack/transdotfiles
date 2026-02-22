{
  plugins = {
    lualine.enable = true;
    web-devicons.enable = true;
    treesitter.enable = true;
    gitsigns.enable = true;
    nvim-autopairs.enable = true;
    lspconfig.enable = true;
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
    bufdelete.enable = true;
    bufferline = {
      enable = true;
      settings = {
        options = {
          close_command.__raw = "  function(bufnum)\n    require('bufdelete').bufdelete(bufnum, true)\n  end\n";
          offsets = [
            {
              filetype = "NvimTree";
              highlight = "Directory";
            }
          ];
        };
      };
    };
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
      };
    };
    comment = {
      enable = true;
      settings = {
        toggler = {
          line = "<leader>/";
          block = "<leader><c-/>";
        };
        opleader = {
          line = "/";
          block = "<c-/>";
        };
      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fw" = "live_grep";
        "<leader>fb" = "buffers";
      };
      settings = {
        defaults = {
          sorting_strategy = "ascending";
          layout_config.prompt_position = "top";
        };
      };
    };
    highlight-colors = {
      enable = true;
      settings = {
        render = "virtual";
        virtual_symbol = "■";
      };
    };
    nvim-tree = {
      enable = true;
      settings = {
        on_attach.__raw = "  function(bufnr)\n    local api = require(\"nvim-tree.api\")\n    local map = vim.keymap.set\n    api.config.mappings.default_on_attach(bufnr)\n    map(\"n\", \"n\", \"h\", { buffer = bufnr, noremap = true, silent = true })\n    map(\"n\", \"e\", \"j\", { buffer = bufnr, noremap = true, silent = true })\n    map(\"n\", \"i\", \"k\", { buffer = bufnr, noremap = true, silent = true })\n    map(\"n\", \"o\", \"l\", { buffer = bufnr, noremap = true, silent = true })\n    map(\"n\", \"<c-n>\", api.tree.toggle, { noremap = true, silent = true })\n  end\n";
      };
    };
  };
}
