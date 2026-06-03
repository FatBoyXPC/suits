{ lib, pkgs, ... }:

{
  globals = {
    shtuff_receiver = lib.nixvim.mkRaw "vim.fn.getcwd()";
    "test#strategy" = "shtuff";
  };

  extraPlugins = [
    pkgs.vimPlugins.vim-test
  ];

  keymaps = [
    {
      key = "<Leader>ts";
      action = ":w<CR>:TestSuite<CR>";
    }
    {
      key = "<Leader>tf";
      action = ":w<CR>:TestFile<CR>";
    }
    {
      key = "<Leader>tl";
      action = ":w<CR>:TestLast<CR>";
    }
    {
      key = "<Leader>tn";
      action = ":w<CR>:TestNearest<CR>";
    }
    {
      key = "<Leader>tv";
      action = ":w<CR>:TestVisit<CR>";
    }
  ];
}
