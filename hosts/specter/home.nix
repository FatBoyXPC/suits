{ pkgs, lib, ... }:

{
  home.file = builtins.mapAttrs (
    dotfile: source:
      { source = ../../dotfiles/${source}; }
    ) (import ../../dotfiles/links.nix);

  dconf.settings."org/gnome/desktop/interface"."gtk-key-theme" = "Emacs";

  home.stateVersion = "25.05";
}
