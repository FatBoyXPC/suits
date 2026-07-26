{
  lib,
  nixos-rebuild,
  python3Packages,
  rsync,
}:

python3Packages.buildPythonApplication {
  pname = "deploy";
  version = "0.1.0";
  pyproject = false;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${./deploy.py} $out/bin/deploy

    runHook postInstall
  '';

  preFixup = ''
    makeWrapperArgs+=("--prefix")
    makeWrapperArgs+=("PATH")
    makeWrapperArgs+=(":")
    makeWrapperArgs+=("${
      lib.makeBinPath [
        nixos-rebuild
        rsync
      ]
    }")
  '';

  meta.mainProgram = "deploy";
}
