{ lib, ... }:

{
  globals.mapleader = " ";
  keymaps = [
    {
      key = "n";
      action = "h";
    }
    {
      key = "e";
      action = "j";
    }
    {
      key = "i";
      action = "k";
    }
    {
      key = "o";
      action = "l";
    }
    {
      key = "j";
      action = "y";
    }
    {
      key = "l";
      action = "u";
    }
    {
      key = "y";
      action = "o";
    }
    {
      key = "u";
      action = "i";
    }
    {
      key = "<c-w>n";
      action = "<c-w>h";
    }
    {
      key = "<c-w>e";
      action = "<c-w>j";
    }
    {
      key = "<c-w>i";
      action = "<c-w>k";
    }
    {
      key = "<c-w>o";
      action = "<c-w>l";
    }
    {
      key = "<tab>";
      action = ":bnext<cr>";
    }
    {
      key = "<s-tab>";
      action = ":bprevious<cr>";
    }
    {
      key = "<leader>x";
      action = ":Bdelete<cr>";
    }
    {
      key = "<c-tab>";
      action = ":tabnext<cr>";
    }
    {
      key = "<c-s-tab>";
      action = ":tabprevious<cr>";
    }
  ];
}
