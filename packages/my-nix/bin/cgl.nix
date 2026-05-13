{ pkgs }:

let
  clipit = pkgs.callPackage ./clipit.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "cgl";

  runtimeInputs = with pkgs; [
    python3
    clipit
  ];

  text = ''
    python3 ${./git-commit-link.py} "$1" | clipit
  '';
}
