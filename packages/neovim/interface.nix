{ pkgs, ... }:
{
  colorscheme = "dim";

  plugins = {
    indent-blankline.enable = true;
    lightline.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    lightline-bufferline
    vim-dim
    vim-polyglot
  ];

  highlightOverride = {
    SignColumn = {
      link = "LineNr";
    };
  };

  globals = {
    lightline = {
      colorscheme = "16color";
      tabline = {
        left = [ [ "buffers" ] ];
        right = [ [ "close" ] ];
      };
      component_expand = {
        buffers = "lightline#bufferline#buffers";
      };
      component_type = {
        buffers = "tabsel";
      };
      separator = {
        left = "";
        right = "";
      };
      subseparator = {
        left = "";
        right = "";
      };
    };

    "lightline#bufferline#min_buffer_count" = 1;
  };
}
