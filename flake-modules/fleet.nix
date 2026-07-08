{
  lib,
  inputs,
  withSystem,
  self,
  ...
}:

let
  nixosDir = ../fleet/nixos;

  evalConfig =
    { hostname }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.disko.nixosModules.disko # <<< TODO: hosts should be able to import things they need, such as disko
        (nixosDir + "/${hostname}/configuration.nix")
        (
          { pkgs, ... }:
          {
            _module.args = {
              inputs' = withSystem pkgs.stdenv.hostPlatform.system ({ inputs', ... }: inputs');
              self' = withSystem pkgs.stdenv.hostPlatform.system ({ self', ... }: self');
            };
          }
        )
      ];
      specialArgs = {
        inherit inputs self;
      };
    };

  nixosDirs = lib.filterAttrs (_hostname: type: type == "directory") (builtins.readDir nixosDir);
  nixosConfigurations = lib.mapAttrs (hostname: _type: evalConfig { inherit hostname; }) nixosDirs;
in

{
  imports =
    (lib.mapAttrsToList (hostname: nixosConfiguration: {
      flake.nixosConfigurations.${hostname} = nixosConfiguration;
      perSystem.checks."hosts/${hostname}" = nixosConfiguration.config.system.build.toplevel;
    }) nixosConfigurations)
    ++ [
      {
        flake.darwinConfigurations.hardman = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ../fleet/darwin/hardman/configuration.nix
            (
              { pkgs, ... }:
              {
                _module.args = {
                  inputs' = withSystem pkgs.stdenv.hostPlatform.system ({ inputs', ... }: inputs');
                  self' = withSystem pkgs.stdenv.hostPlatform.system ({ self', ... }: self');
                };
              }
            )
          ];
          specialArgs = { inherit inputs; };
        };
      }
    ];
}
