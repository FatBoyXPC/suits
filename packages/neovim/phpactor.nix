{ pkgs, ... }:

{
  extraPlugins = [
    pkgs.vimPlugins.phpactor
  ];

  files."after/ftplugin/php.lua".keymaps = [
    {
      key = "<Leader>ec";
      action = ":PhpactorClassExpand<CR>";
      options.buffer = true;
    }
    {
      key = "<Leader>ee";
      action = ":PhpactorExtractExpression<CR>";
      options.buffer = true;
    }
    {
      key = "<Leader>ee";
      action = ":<C-u>PhpactorExtractExpression<CR>";
      mode = "v";
      options.buffer = true;
    }
    {
      key = "<Leader>em";
      action = ":<C-u>PhpactorExtractMethod<CR>";
      mode = "v";
      options.buffer = true;
    }
    {
      key = "<Leader>ic";
      action = ":PhpactorImportClass<CR>";
      options.buffer = true;
    }
    {
      key = "<Leader>im";
      action = ":PhpactorImportMissingClasses<CR>";
      options.buffer = true;
    }
    {
      key = "<Leader>mi";
      action = ":PhpactorImportMissingClasses<CR>";
      options.buffer = true;
    }
    {
      key = "<Leader>mm";
      action = ":PhpactorContextMenu<CR>";
      options.buffer = true;
    }
  ];
}
