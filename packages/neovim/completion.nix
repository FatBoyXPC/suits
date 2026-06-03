{
  extraConfigLuaPost = builtins.readFile ./completion.lua;

  plugins = {
    cmp.enable = true;
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-path.enable = true;
  };
}
