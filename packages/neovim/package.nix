{
  pkgs,
  inputs',
  self',
  ...
}:

inputs'.nixvim.legacyPackages.makeNixvimWithModule {
  inherit pkgs;
  extraSpecialArgs = { inherit self'; };
  module = {
    extraConfigVim = ''
      scriptencoding utf-8

      highlight ColorColumn ctermfg=8 ctermbg=7
      highlight NonText ctermfg=8
      highlight TabLineFill cterm=NONE

      if filereadable("project.vim")
        source project.vim
      endif
    '';

    imports = [
      ./completion.nix
      ./git.nix
      ./interface.nix
      ./lsp.nix
      ./mappings.nix
      ./markdown.nix
      ./phpactor.nix
      ./settings.nix
      ./snippets
      ./telescope.nix
      ./testing.nix
    ];

    plugins = {
      bufdelete.enable = true;
      nvim-autopairs.enable = true;
      sandwich.enable = true;
      tagbar.enable = true;
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nerdcommenter
    ];

    globals = {
      NERDCreateDefaultMappings = 0;
    };
  };
}
