{ pkgs, self' }:

pkgs.writeShellApplication {
  name = "clcl";

  runtimeInputs = with pkgs; [
    self'.packages.cgl
    git
  ];

  text = ''
    cgl "$(git rev-parse HEAD)"
  '';
}
