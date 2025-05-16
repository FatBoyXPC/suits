{
  self,
  inputs,
  lib,
  ...
}:

{
  perSystem =
    {
      self',
      inputs',
      system,
      pkgs,
      config,
      ...
    }:
    let
      pkgArgs = {
        inherit
          inputs
          inputs'
          self
          self'
          system
          ;
      };
    in
    {
      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = pkgs.newScope pkgArgs;
        directory = ../packages;
      };

      # Add checks to build each package.
      checks = lib.pipe self'.packages [
        # `checks` is a global namespace, so prefix each check so it
        # (hopefully) gets a unique name.
        (lib.mapAttrs' (
          name: package: {
            name = "packages/${name}";
            value = package;
          }
        ))
        # Filter out packages we shouldn't build during flake check.
        (lib.filterAttrs (
          name: package:
          !(lib.attrByPath [
            "passthru"
            "skipFlakeCheckBuild"
          ] false package)
        ))
      ];
    };
}
