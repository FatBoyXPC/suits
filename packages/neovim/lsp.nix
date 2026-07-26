{
  plugins = {
    lsp.enable = true;
    lsp-format = {
      enable = true;
      lspServersToEnable = "none";
    };

    none-ls = {
      enable = true;
      sources.formatting.nix_flake_fmt.enable = true;
    };
  };

  diagnostic.settings.virtual_text = true;

  lsp = {
    inlayHints.enable = true;

    servers = {
      bashls.enable = true;
      nixd.enable = true;
      phpactor.enable = true;

      # Python
      pyright.enable = true;
      ruff.enable = true;
    };

    keymaps = [
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
  };
}
