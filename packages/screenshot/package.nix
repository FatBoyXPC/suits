{ pkgs }:

pkgs.writeShellApplication {
  name = "screenshot";

  runtimeInputs = with pkgs; [
    shotgun
    satty
  ];

  text = ''
    shotgun /dev/stdout | satty -f - --initial-tool crop --early-exit --actions-on-enter save-to-file
  '';
}
