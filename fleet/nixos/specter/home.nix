{ pkgs, lib, ... }:

{
  imports = [
    ./omz.nix
  ];

  home.file = builtins.mapAttrs (dotfile: source: {
    source = ../../../dotfiles/${source};
  }) (import ../../../dotfiles/links.nix);

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;

    package = pkgs.quintom-cursor-theme;
    name = "Quintom_Ink";
    size = 45;
  };

  dconf.settings."org/gnome/desktop/interface"."gtk-key-theme" = "Emacs";

  home.stateVersion = "25.05";
}
