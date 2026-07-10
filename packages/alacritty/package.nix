{
  alacritty,
  makeWrapper,
  symlinkJoin,
}:

symlinkJoin {
  name = "alacritty";

  paths = [ alacritty ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/alacritty \
      --set SHLVL 0
  '';
}
