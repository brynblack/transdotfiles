{ ... }:

let
  # Normal mode only. In visual mode a ":" mapping gets '<,'> prepended, which
  # breaks commands that take no range.
  mkMap = key: action: {
    inherit key action;
    mode = "n";
  };
in
{
  globals.mapleader = " ";

  # Colemak: hjkl shifted one key right onto neio, with the keys that displaces
  # moved along (j->y, l->u, y->o, u->i), then search-next and end-of-word on
  # the k and h freed up. Written as typed;meaning.
  #
  # Unlike mappings, langmap translates keys before mapping lookup, so plugins'
  # buffer-local j/k and <c-w> targets follow it too. It leaves Insert, Select
  # and Command-line mode alone (so typing over a snippet placeholder works)
  # and doesn't touch the character after f/t/r.
  #
  # Mapping lhs below are matched after translation, so a key typed as h has to
  # be written as e, k as n, and so on.
  opts.langmap = "neiojlyukh;hjklyuoine";

  keymaps = [
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
            local bufnr = vim.fn.bufnr()
            if #vim.api.nvim_list_wins() > 1 then
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
    (mkMap "<c-tab>" "<cmd>tabnext<cr>")
    (mkMap "<c-s-tab>" "<cmd>tabprevious<cr>")
    (mkMap "grd" "<cmd>lua vim.lsp.buf.definition()<cr>")
    (mkMap "grD" "<cmd>lua vim.lsp.buf.declaration()<cr>")
    # Neovim's own grn and gri, typed as grn and gri. Their lhs would otherwise
    # only match when typed as grk and gru.
    (mkMap "grh" "<cmd>lua vim.lsp.buf.rename()<cr>")
    (mkMap "grk" "<cmd>lua vim.lsp.buf.implementation()<cr>")
    (mkMap "<esc>" "<cmd>noh<cr>")
    (mkMap "<c-s>" "<cmd>w<cr>")
    {
      # oil opens in the current window rather than a sidebar, so toggling
      # means going back to the buffer it replaced.
      key = "<c-n>";
      mode = "n";
      action.__raw = ''
        function()
          if vim.bo.filetype == "oil" then
            require("oil").close()
          else
            require("oil").open()
          end
        end
      '';
    }
    # Typed as <leader>h, <leader>th and <leader>tk (see langmap above).
    (mkMap "<leader>e" "<cmd>belowright split | terminal<cr>i")
    (mkMap "<leader>v" "<cmd>belowright vsplit | terminal<cr>i")
    (mkMap "<leader>te" "<cmd>Telescope colorscheme enable_preview=true<cr>")
    (mkMap "<leader>tn" "<cmd>Telescope keymaps<cr>")
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
      mode = "x";
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
      mode = "x";
      options.remap = true;
    }
  ];
}
