{
  plugins.lsp.enable = true;
  diagnostic.settings.virtual_text = true;
  lsp.servers.phpactor.enable = true;

  keymaps = [
    {
      key = "gd";
      action = ":lua vim.lsp.buf.definition()<CR>";
    }
    {
      key = "<Leader>gt";
      action = ":lua vim.lsp.buf.type_definition()<CR>";
    }
    {
      key = "<Leader>gi";
      action = ":lua vim.lsp.buf.implementation()<CR>";
    }
    {
      key = "<Leader>gr";
      action = ":lua vim.lsp.buf.references()<CR>";
    }
    {
      key = "<Leader>ac";
      action = ":lua vim.lsp.buf.code_action()<CR>";
    }
  ];
}
