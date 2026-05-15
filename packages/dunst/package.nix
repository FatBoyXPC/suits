{
  replaceVars,
  dunst,
  dmenu,
  makeWrapper,
  symlinkJoin,
  writeShellApplication,
  xdg-utils,
}:

let
  config = replaceVars ./dunstrc {
    inherit dmenu;
    xdg_utils = xdg-utils;
  };
  dunst-pause = writeShellApplication {
    name = "dunst-pause";
    runtimeInputs = [ dunst ];
    text = ''
      dunstctl set-paused true
    '';
  };
  dunst-resume = writeShellApplication {
    name = "dunst-resume";
    runtimeInputs = [ dunst ];
    text = ''
      dunstctl set-paused false
    '';
  };
in
symlinkJoin {
  name = "dunst";
  paths = [
    dunst
    dunst-pause
    dunst-resume
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/dunst \
        --add-flags "-config ${config}"
  '';
}
