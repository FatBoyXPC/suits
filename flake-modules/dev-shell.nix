{
  perSystem =
    { pkgs, self', ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nixos-rebuild
          self'.packages.deploy
        ];
      };
    };
}
