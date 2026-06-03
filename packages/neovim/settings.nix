{
  autoCmd = [
    {
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
      callback.__raw = ''
        function()
        vim.cmd([[
          let _s=@/ " Preparation: save last search, and cursor position.
          let l = line(".")
          let c = col(".")
          " do the business:
          %s/\s\+$//e
          let @/=_s " clean up: restore previous search history, and cursor position
          call cursor(l, c)
        ]])
        end
      '';
    }
  ];

  opts = {

    # General
    syntax = "on";
    hidden = true;
    #history = 1000;
    nrformats = "alpha,bin,hex";
    wildmenu = true;
    wildmode = "list:longest,full";
    backspace = "indent,eol,start";
    backup = false;
    mouse = "";
    #directory = "";
    #undodir = "";
    undofile = true;
    undolevels = 1000;
    undoreload = 10000;
    spell = true;
    clipboard = "unnamed,unnamedplus";

    # UI:
    termguicolors = false;
    background = "dark";
    number = true;
    relativenumber = true;
    showmatch = true;
    cursorline = true;
    title = true;
    laststatus = 2;
    showcmd = true;
    tabpagemax = 15;
    showmode = false;
    colorcolumn = [
      80
      120
    ];
    splitbelow = true;
    splitright = true;
    foldenable = false;
    showtabline = 2;

    # Formatting:
    list = true;
    listchars = "tab:›\ ,trail:•,extends:#,nbsp:.";
    wrap = false;
    shiftwidth = 4;
    expandtab = true;
    tabstop = 4;
    softtabstop = 4;
    joinspaces = true;

    # Search:
    incsearch = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true;
  };
}
