{ lib, pkgs, ... }:

let
  python3 = lib.getExe pkgs.python3;
in
{
  globals.mapleader = " ";

  keymaps = [
    {
      key = "<Leader>c";
      action = ":Bd<CR>";
    }
    {
      key = "<Leader>w";
      action = ":update<CR>";
    }
    {
      key = "<Leader>W";
      action = ":update!<CR>";
    }
    {
      key = "<Leader>q";
      action = ":q<CR>";
    }
    {
      key = "<Leader>st";
      action = ":set spell!<CR>";
    }

    # Not sure if I want to keep this around
    {
      key = "<Leader>fr";
      action = ":w<CR>:call system('fat-rerunner ' . shellescape(g:shtuff_receiver))<CR>";
    }

    # Files
    {
      key = "<Leader>pc";
      action = ":let @+ = fnamemodify(expand('%'), ':~:.')<CR>";
    }
    {
      key = "<Leader>sp";
      action = ":e ~/scratchpad<CR>";
    }

    # Editing
    {
      key = "<Leader>;;";
      action = "<ESC>A;<ESC>";
      mode = [
        "n"
      ];
    }
    {
      key = ";;";
      action = "<ESC>A;<ESC>";
      mode = [
        "i"
      ];
    }
    {
      key = "<Leader>::";
      action = "<ESC>A:<ESC>";
      mode = [
        "n"
      ];
    }
    {
      key = "::";
      action = "<ESC>A:<ESC>";
      mode = [
        "i"
      ];
    }
    {
      key = "<Leader>,,";
      action = "<ESC>A,<ESC>";
      mode = [
        "n"
      ];
    }
    {
      key = ",,";
      action = "<ESC>A,<ESC>";
      mode = [
        "i"
      ];
    }
    {
      key = "S";
      action = "<Plug>(operator-sandwich-add)";
      mode = "x";
    }
    {
      key = "Y";
      action = "y$";
    }
    {
      key = "<Leader>tw";
      action = ":set wrap!<CR>";
    }
    {
      key = "<C-_>";
      action = "<Plug>NERDCommenterToggle";
      mode = [
        "n"
        "x"
      ];
    }
    {
      key = "<C-/>";
      action = "<Plug>NERDCommenterToggle";
      mode = [
        "n"
        "x"
      ];
    }
    # Allow using the repeat operator with a visual selection (!)
    # http://stackoverflow.com/a/8064607/127816
    {
      key = ".";
      action = ":normal .<CR>";
      mode = "v";
    }
    {
      key = "<C-J>";
      action = ":m .+1<CR>==";
    }
    {
      key = "<C-K>";
      action = ":m .-2<CR>==";
    }
    {
      key = "<C-J>";
      action = "<Esc>:m .+1<CR>==gi";
      mode = "i";
    }
    {
      key = "<C-K>";
      action = "<Esc>:m .-2<CR>==gi";
      mode = "i";
    }
    {
      key = "<C-J>";
      action = ":m '>+1<CR>gv=gv";
      mode = "v";
    }
    {
      key = "<C-K>";
      action = ":m '>-2<CR>gv=gv";
      mode = "v";
    }

    # Formatting
    {
      key = "<Leader>fj";
      action = ":%!${python3} -m json.tool<CR>";
    }
    {
      key = "<Leader>fj";
      action = ":!${python3} -m json.tool<CR>";
      mode = "x";
    }
    {
      key = "<Leader>fx";
      action = ":%!${python3} -c 'import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())'<CR>";
    }
    {
      key = "<Leader>fx";
      action = ":%!${python3} -c 'import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())'<CR>";
      mode = "x";
    }
    {
      key = "<Leader>x12";
      action = ":%s/\n//g<cr>:%s/\~/\~\r/g<cr>gg:nohlsearch<cr>";
    }

    # Navigation
    {
      key = "<Leader><Leader>";
      action = "<C-^>";
    }
    {
      key = "<Leader>ut";
      action = ":UndotreeToggle<CR>";
    }

    # Search
    {
      key = "<Leader>t/";
      action = ":set invhlsearch<CR>";
    }
  ];
}
