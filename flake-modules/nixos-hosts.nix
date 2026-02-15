{
  lib,
  inputs,
  withSystem,
  self,
  ...
}:

let
  hostsDir = ../hosts;

  evalConfig =
    { hostname }:
    inputs.nixpkgs.lib.nixosSystem {
      #system = null;
      modules = [
        inputs.disko.nixosModules.disko # <<< TODO: hosts should be able to import things they need, such as disko
        inputs.vpn-confinement.nixosModules.default
        (hostsDir + "/${hostname}/configuration.nix")
        (
          { pkgs, ... }:
          {
            _module.args = {
              inputs' = withSystem pkgs.system ({ inputs', ... }: inputs');
              self' = withSystem pkgs.system ({ self', ... }: self');
            };
          }
        )
      ];
      specialArgs = {
        inherit inputs self;
      };
    };

  hostDirs = lib.filterAttrs (_hostname: type: type == "directory") (builtins.readDir hostsDir);
  nixosConfigurations = lib.mapAttrs (hostname: _type: evalConfig { inherit hostname; }) hostDirs;
in

{
  imports = lib.mapAttrsToList (hostname: nixosConfiguration: {
    flake.nixosConfigurations.${hostname} = nixosConfiguration;
    perSystem.checks."hosts/${hostname}" = nixosConfiguration.config.system.build.toplevel;
  }) nixosConfigurations;
}
