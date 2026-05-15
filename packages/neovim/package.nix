{
  pkgs,
  inputs,
  system,
  lib,
  ...
}:

inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    extraConfigVim = ''
      let g:clipboard='osc52'
      let g:configPath=$HOME.'/.vim'

      ${builtins.readFile ./functions.vim}
      ${builtins.readFile ./mappings.vim}
      ${builtins.readFile ./myrc.vim}
      ${builtins.readFile ./plugins.vim}
    '';

    extraConfigLuaPost = builtins.readFile ./nvim-specific.lua;

    plugins =
      builtins.listToAttrs (
        map (x: (lib.nameValuePair x { enable = true; })) [
          "bufdelete"
          "cmp"
          "cmp-buffer"
          "cmp-cmdline"
          "cmp-nvim-lsp"
          "cmp-nvim-lsp-signature-help"
          "cmp-path"
          "fugitive"
          "gitgutter"
          "indent-blankline"
          "lightline"
          "lsp"
          "lspconfig"
          "markdown-preview"
          "nvim-autopairs"
          "sandwich"
          "tagbar"
          "telescope"
          "undotree"
        ]
      )
      // {
        web-devicons.enable = false;
        lsp.servers = {
          phpactor.enable = true;
        };
      };

    extraPlugins = with pkgs.vimPlugins; [
      lightline-bufferline
      nerdcommenter
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-live-grep-args-nvim
      telescope-ui-select-nvim
      ultisnips
      vim-dim
      vim-gista
      vim-polyglot
      vim-rhubarb
      vim-test
    ];
  };
}
