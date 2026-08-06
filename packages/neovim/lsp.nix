{
  lib,
  pkgs,
  self',
  ...
}:

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

    lsp.servers.laravel_ls = {
      enable = true;
      package = self'.packages.laravel-lsp;
      cmd = [ "laravel-lsp" ];
      filetypes = [
        "php"
        "blade"
      ];
      rootMarkers = [
        "artisan"
        "composer.json"
        ".git"
      ];
      extraOptions.init_options.phpCommand = [ "${lib.getExe pkgs.php}" ];
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
