{
  plugins.markdown-preview = {
    enable = true;
    settings.auto_close = 0;
  };

  keymaps = [
    {
      key = "<Leader>mp";
      action = ":MarkdownPreview<CR>";
    }
    {
      key = "<Leader>ms";
      action = ":w<CR>:MarkdownPreviewStop<CR>:Bd<CR>";
    }
  ];
}
