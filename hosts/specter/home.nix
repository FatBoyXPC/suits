{ pkgs, lib, ... }:

{
  home.file = builtins.mapAttrs (
    dotfile: source:
      { source = ../../dotfiles/${source}; }
    ) (import ../../dotfiles/links.nix);


  home.stateVersion = "25.05";
}
