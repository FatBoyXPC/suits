{
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  stdenv,
}:

let
  versionMajor = "9.5";
  versionMinor = "7";
  versionBuild_x86_64 = "2";
  versionBuild_i686 = "2";
  version = "${versionMajor}.${versionMinor}";
in
stdenv.mkDerivation {
  pname = "nomachine-client-usb-kernel-module";
  inherit version;

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://download.nomachine.com/download/${versionMajor}/Linux/nomachine_${version}_${versionBuild_x86_64}_x86_64.tar.gz";
        sha256 = "sha256-8f4ZL3Ko5VunojXLvTS9P3oB+ZVCSYIA0GIjM8VpUO4=";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "https://download.nomachine.com/download/${versionMajor}/Linux/nomachine_${version}_${versionBuild_i686}_i686.tar.gz";
        sha256 = "sha256-Yr0bw7PW34Nga8vj3TxdFFyDiVVnHJ6lBdNskOyQ8m8=";
      }
    else
      throw "NoMachine client is not supported on ${stdenv.hostPlatform.system}";

  postUnpack = ''
    mv $(find . -type f -name nxrunner.tar.gz) .
    tar xf nxrunner.tar.gz
  '';

  preBuild = ''
    cd share/src/nxusb/
    substituteInPlace Makefile \
      --replace-fail "/bin/uname" "uname"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
}
