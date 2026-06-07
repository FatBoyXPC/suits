{
  plugins.lsp.enable = true;
  diagnostic.settings.virtual_text = true;
  lsp.servers.phpactor.enable = true;

  lsp.keymaps = [
    {
      key = "gd";
      lspBufAction = "definition";
    }
    {
      key = "<Leader>gt";
      lspBufAction = "type_definition";
    }
    {
      key = "<Leader>gi";
      lspBufAction = "implementation";
    }
    {
      key = "<Leader>gr";
      lspBufAction = "references";
    }
    {
      key = "<Leader>ac";
      lspBufAction = "code_action";
    }
  ];
}
