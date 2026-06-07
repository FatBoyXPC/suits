{
  extraConfigLuaPost = builtins.readFile ./telescope.lua;

  plugins = {
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        live-grep-args.enable = true;
        ui-select.enable = true;
        undo.enable = true;
      };
      keymaps = {
        "<Leader>b" = "buffers sort_lastused=true";
        "<Leader>P" = "pickers";
        "<Leader>R" = "resume";
        "<C-P>" = "git_files";
        "<Leader>af" = "find_files";
        "<Leader>lf" = "laravel_picker";
        "<Leader>mf" = "git_status";
        "<Leader>fu" = "lsp_document_methods";
        "<Leader>/" = "live_grep";
      };
    };
    web-devicons.enable = false;
  };

  keymaps = [
    {
      key = "<Leader>T";
      action = ":Telescope<CR>";
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
