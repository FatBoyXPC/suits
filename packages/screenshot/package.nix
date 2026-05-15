{ pkgs }:

pkgs.writeShellApplication {
  name = "screenshot";

  runtimeInputs = with pkgs; [
    shotgun
    xclip
    satty
  ];

  text = ''
    shotgun /dev/stdout | satty -f - --initial-tool crop --early-exit --actions-on-enter save-to-file --copy-command "xclip -selection clipboard -target image/png -in"
  '';
}
