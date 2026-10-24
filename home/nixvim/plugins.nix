{ lib, ... }:

{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";
        sources.default = [
          "lsp"
          "path"
          "buffer"
          "snippets"
        ];
      };
    };
    bufdelete.enable = true;
    # Provides gb/gbc block comments; Neovim's built-in commenting has only gc.
    comment.enable = true;
    bufferline = {
      enable = true;
      settings = {
        options = {
          close_command.__raw = ''
            function(bufnum)
              require('bufdelete').bufdelete(bufnum, true)
            end
          '';
          custom_filter.__raw = ''
            function(buf_number)
              return vim.bo[buf_number].buftype ~= "terminal"
            end
          '';
          # Otherwise these are set as defaults, which an existing group wins
          # over, so a re-theme would never reach the tabline.
          themable = false;
        };
        # Every group transparent. Icon highlights are created lazily from
        # these, so they inherit it too. The selected tab loses its block, so
        # it is bold instead.
        highlights.__raw = ''
          function(defaults)
            local hl = {}
            for name, attrs in pairs(defaults.highlights) do
              hl[name] = vim.tbl_extend("force", attrs, { bg = "NONE" })
            end
            hl.buffer_selected.bold = true
            return hl
          end
        '';
      };
    };
    direnv.enable = true;
    gitsigns.enable = true;
    highlight-colors = {
      enable = true;
      settings = {
        render = "virtual";
        virtual_symbol = "■";
      };
    };
    # Colours come from IblIndent/IblScope in the noctalia template.
    indent-blankline.enable = true;
    lspconfig.enable = true;
    lualine = {
      enable = true;
      settings.options.theme = "noctalia";
    };
    nvim-autopairs.enable = true;
    oil = {
      enable = true;
      # oil binds <C-s> to open in a vsplit, which would shadow the global
      # <c-s> save. Saving is also how oil applies its edits to the filesystem.
      settings.keymaps."<C-s>" = false;
    };
    scope.enable = true;
    telescope = {
      enable = true;
      enabledExtensions = [ "scope" ];
      extensions.fzf-native.enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fw" = "live_grep";
        "<leader>fb" = "buffers";
      };
      settings = {
        defaults = {
          sorting_strategy = "ascending";
          layout_config.prompt_position = "top";
          borderchars = lib.replicate 8 " ";
        };
      };
    };
    treesitter = {
      enable = true;
      # Off by default on nvim-treesitter's main branch, which leaves every
      # grammar installed but unused outside Neovim's own lua/help/markdown.
      highlight.enable = true;
    };
    web-devicons.enable = true;
  };
}
