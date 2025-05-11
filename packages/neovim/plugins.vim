"set rtp+=~/dotfiles/my-nix/result/share/vim-plugins/fzf
"let g:fzf_layout = { 'down': '~40%' }

if filereadable(".php_cs.dist")
    let g:php_cs_fixer_config_file = '.php_cs.dist'
endif

if filereadable(".php_cs")
    let g:php_cs_fixer_config_file = '.php_cs'
endif

let g:NERDCreateDefaultMappings = 0

"let g:vdebug_options = {"break_on_open": 0}
"let g:vdebug_features = {'max_children': 1024}
"let g:phpactorPhpBin = '/usr/bin/php'
"let g:phpactorBranch = 'develop'
"let g:phpactorOmniAutoClassImport = 1
let g:gista#command#post#default_public = 0
let test#strategy = "shtuff"

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:mkdp_auto_close = 0
