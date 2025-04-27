{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "interception-k2k";
  src = fetchFromGitHub {
    owner = "zsugabubus";
    repo = "interception-k2k";
    rev = "5746bf39a321610bb6019781034f82e4c6e21e97";
    hash = "sha256-q2zlOvyW5jlasEIPVc+k6jh2wJZ7sUEpvXh/leH/hKw=";
  };
  preBuild = ''
    cp -r ${./print2superL} examples/print2superL
    chmod -R +w examples/print2superL
  '';
  installPhase = ''
    mkdir -p $out/bin
    INSTALL_DIR=$out/bin make install
  '';
}
