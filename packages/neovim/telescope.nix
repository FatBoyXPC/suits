{ pkgs, ... }:

{
  extraConfigLuaPost = builtins.readFile ./telescope.lua;

  plugins = {
    telescope.enable = true;
    web-devicons.enable = false;
  };

  extraPlugins = with pkgs.vimPlugins; [
    telescope-fzf-native-nvim
    telescope-live-grep-args-nvim
    telescope-ui-select-nvim
  ];

  keymaps = [
    # Navigation
    {
      key = "<Leader>b";
      action = ":Telescope buffers sort_lastused=true<CR>";
    }
    {
      key = "<Leader>P";
      action = ":Telescope pickers<CR>";
    }
    {
      key = "<Leader>R";
      action = ":Telescope resume<CR>";
    }
    {
      key = "<Leader>T";
      action = ":Telescope<CR>";
    }
    {
      key = "<C-P>";
      action = ":Telescope git_files<CR>";
    }
    {
      key = "<Leader>af";
      action = ":Telescope find_files<CR>";
    }
    {
      key = "<Leader>lf";
      action = ":Telescope laravel_picker<CR>";
    }
    {
      key = "<Leader>mf";
      action = ":Telescope git_status<CR>";
    }
    {
      key = "<Leader>fu";
      action = ":Telescope lsp_document_methods<CR>";
    }

    # Search
    {
      key = "<Leader>/";
      action = ":Telescope live_grep<CR>";
    }
    {
      key = "<Leader>/";
      action.__raw = "require('telescope-live-grep-args.shortcuts').grep_visual_selection";
      mode = "v";
    }
    {
      key = "<Leader>*";
      action = ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>";
    }
  ];
}
