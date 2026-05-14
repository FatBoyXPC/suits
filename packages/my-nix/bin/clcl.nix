{ pkgs }:

let
  clipit = pkgs.callPackage ./clipit.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "clcl";

  runtimeInputs = with pkgs; [
    cgl
    git
  ];

  text = ''
    cgl "$(git rev-parse HEAD)"
  '';
}
