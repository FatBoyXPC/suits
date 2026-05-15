{
  self',
  writeShellApplication,
  git,
}:

writeShellApplication {
  name = "clcl";

  runtimeInputs = [
    self'.packages.cgl
    git
  ];

  text = ''
    cgl "$(git rev-parse HEAD)"
  '';
}
