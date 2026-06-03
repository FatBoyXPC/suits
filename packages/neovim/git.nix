{ pkgs, ... }:

{
  plugins = {
    fugitive.enable = true;
    gitgutter.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-gista
    vim-rhubarb
  ];

  globals."gista#command#post#default_public" = 0;

  keymaps = [
    {
      key = "<Leader>fc";
      action = "/\v^[<\|=>]{7}( .*\|$)<CR>";
    }
    {
      key = "<Leader>gb";
      action = ":Git blame<CR>";
    }
  ];
}
