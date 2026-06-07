{
  extraConfigLuaPost = builtins.readFile ./completion.lua;

  plugins = {
    cmp = {
      enable = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "nvim_lsp_signature_help"; }
        {
          name = "path";
          option.get_cwd.__raw = ''
            function()
              return vim.fn.getcwd()
            end
          '';
        }
        { name = "buffer"; }
      ];
    };
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-path.enable = true;
  };
}
