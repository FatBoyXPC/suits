{ newScope, pkgs }:

let
  self = rec {
    # Pull some all of pkgs.kodiPackages into scope + cleverly make the new kodi
    # packages we're defining available as well so they can depend on each other.
    callPackage = newScope (pkgs.kodiPackages // self);

    asgard = callPackage ./asgard { };
  };
in
self
