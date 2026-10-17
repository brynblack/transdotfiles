{ defaultGuifont }:

let
  # Motions apply in every mode the original key does: normal, visual,
  # select and operator-pending.
  mkMotion = key: action: { inherit key action; };
  # Everything else is normal mode only. In visual mode a ":" mapping gets
  # '<,'> prepended, which breaks commands that take no range.
  mkMap = key: action: {
    inherit key action;
    mode = "n";
  };

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
    (map ({ from, to }: mkMotion from to) colemakAll)
    ++ (map ({ from, to }: mkMotion "<c-w>${from}" "<c-w>${to}") colemakMotion)
    ++ [
      {
        key = "<tab>";
        mode = "n";
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
        mode = "n";
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
        mode = "n";
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
      {
        key = "<c-=>";
        mode = "n";
        action.__raw = ''
          function()
            local font, size = vim.o.guifont:match("^(.*):h(%d+)$")
            if font and size then
              vim.o.guifont = font .. ":h" .. (tonumber(size) + 1)
            end
          end
        '';
      }
      {
        key = "<c-->";
        mode = "n";
        action.__raw = ''
          function()
            local font, size = vim.o.guifont:match("^(.*):h(%d+)$")
            if font and size and tonumber(size) > 1 then
              vim.o.guifont = font .. ":h" .. (tonumber(size) - 1)
            end
          end
        '';
      }
      (mkMap "<c-0>" "<cmd>set guifont=${builtins.replaceStrings [ " " ] [ "\\ " ] defaultGuifont}<cr>")
      (mkMap "<c-tab>" "<cmd>tabnext<cr>")
      (mkMap "<c-s-tab>" "<cmd>tabprevious<cr>")
      (mkMap "grd" "<cmd>lua vim.lsp.buf.definition()<cr>")
      (mkMap "grD" "<cmd>lua vim.lsp.buf.declaration()<cr>")
      (mkMap "<esc>" "<cmd>noh<cr>")
      (mkMap "<c-s>" "<cmd>w<cr>")
      (mkMap "<c-n>" "<cmd>Neotree toggle<cr>")
      (mkMap "<leader>h" "<cmd>belowright split | terminal<cr>i")
      (mkMap "<leader>v" "<cmd>belowright vsplit | terminal<cr>i")
      (mkMap "<leader>th" "<cmd>Telescope colorscheme enable_preview=true<cr>")
      (mkMap "<leader>tk" "<cmd>Telescope keymaps<cr>")
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
