{
  dmenu,
  symlinkJoin,
  makeWrapper,
}:

symlinkJoin {
  name = "dmenu_run";
  paths = [ dmenu ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    for prog in dmenu dmenu_run; do
      wrapProgram $out/bin/$prog \
        --add-flags "-fn 'UbuntuMono Nerd Font:size=18'"
    done
  '';
}
