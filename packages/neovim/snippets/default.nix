{ pkgs, ... }:

let
  fat-snippets = pkgs.vimUtils.buildVimPlugin {
    pname = "fat-snippets";
    version = "0.0.0";
    src = ./.;
  };
in
{
  extraPlugins = [
    fat-snippets
    pkgs.vimPlugins.ultisnips
  ];

  globals = {
    UltiSnipsExpandTrigger = "<tab>";
    UltiSnipsJumpForwardTrigger = "<tab>";
    UltiSnipsJumpBackwardTrigger = "<s-tab>";
  };
}
