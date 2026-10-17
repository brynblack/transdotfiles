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
          offsets = [
            {
              filetype = "neo-tree";
              highlight = "Directory";
            }
          ];
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
    neo-tree = {
      enable = true;
      settings = {
        filesystem.follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };
        window.mappings = {
          "n".__raw = "function() vim.cmd('normal! h') end";
          "e".__raw = "function() vim.cmd('normal! j') end";
          "i".__raw = "function() vim.cmd('normal! k') end";
          "o".__raw = "function() vim.cmd('normal! l') end";
        };
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
