{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, self, ... }:
    let
      inherit (nixpkgs) lib;
      hosts = lib.filterAttrs (hostname: filetype: filetype == "directory") (builtins.readDir ./hosts);

      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgArgs = { flake = self; };
      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = pkgs.newScope pkgArgs;
        directory = ./packages;
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs (hostname: filetype: lib.nixosSystem {
        system = "x86_64-linux"; # <<< TODO: live in host rather than be hardcoded
        modules = [
          disko.nixosModules.disko # <<< TODO: hosts should be able to import things they need, such as disko
          (./hosts + "/${hostname}/configuration.nix")
        ];
      }) hosts;

      packages.x86_64-linux = packages; # <<< TODO: do not hardcode the system here, either!
    };
}
