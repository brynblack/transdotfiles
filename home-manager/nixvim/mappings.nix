let
  mkMap = key: action: { inherit key action; };

  colemakMotion = [
    {
      from = "n";
      to = "h";
    }
    {
      from = "e";
      to = "j";
    }
    {
      from = "i";
      to = "k";
    }
    {
      from = "o";
      to = "l";
    }
  ];

  colemakAll = colemakMotion ++ [
    {
      from = "j";
      to = "y";
    }
    {
      from = "l";
      to = "u";
    }
    {
      from = "y";
      to = "o";
    }
    {
      from = "u";
      to = "i";
    }
  ];
in
{
  globals.mapleader = " ";
  keymaps =
    (map ({ from, to }: mkMap from to) colemakAll)
    ++ (map ({ from, to }: mkMap "<c-w>${from}" "<c-w>${to}") colemakMotion)
    ++ [
      {
        key = "<tab>";
        action.__raw = ''
          function()
            if vim.bo.buftype ~= "terminal" then
              vim.cmd("BufferLineCycleNext")
            end
          end
        '';
      }
      {
        key = "<s-tab>";
        action.__raw = ''
          function()
            if vim.bo.buftype ~= "terminal" then
              vim.cmd("BufferLineCyclePrev")
            end
          end
        '';
      }
      {
        key = "<leader>x";
        action.__raw = ''
          function()
            if vim.bo.buftype == "terminal" then
              local non_tree_wins = vim.tbl_filter(function(w)
                return vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= "neo-tree"
              end, vim.api.nvim_list_wins())
              local bufnr = vim.fn.bufnr()
              if #non_tree_wins > 1 then
                vim.cmd("close")
                vim.cmd("bdelete! " .. bufnr)
              else
                require("bufdelete").bufdelete(0, true)
              end
            else
              vim.cmd("Bdelete")
            end
          end
        '';
      }
      (mkMap "<c-tab>" ":tabnext<cr>")
      (mkMap "<c-s-tab>" ":tabprevious<cr>")
      (mkMap "grd" ":lua vim.lsp.buf.definition()<cr>")
      (mkMap "grD" ":lua vim.lsp.buf.declaration()<cr>")
      (mkMap "<esc>" ":noh<cr>")
      (mkMap "<c-s>" ":w<cr>")
      (mkMap "<c-n>" ":Neotree toggle<cr>")
      (mkMap "<leader>h" ":belowright split | terminal<cr>i")
      (mkMap "<leader>v" ":belowright vsplit | terminal<cr>i")
      (mkMap "<leader>th" ":Telescope colorscheme enable_preview=true<cr>")
      {
        key = "<c-x>";
        action = "<c-\\><c-n>";
        mode = "t";
      }
      {
        key = "<leader>/";
        action = "gcc";
        mode = "n";
        options.remap = true;
      }
      {
        key = "<leader>/";
        action = "gc";
        mode = "v";
        options.remap = true;
      }
      {
        key = "<leader><c-/>";
        action = "gbc";
        mode = "n";
        options.remap = true;
      }
      {
        key = "<leader><c-/>";
        action = "gb";
        mode = "v";
        options.remap = true;
      }
    ];
}
