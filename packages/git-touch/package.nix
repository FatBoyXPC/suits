{
  coreutils,
  git,
  writeShellApplication,
}:

writeShellApplication {
  name = "git-touch";

  runtimeInputs = [
    coreutils
    git
  ];

  text = ''
    touch "$@"
    git add -N "$@"
  '';
}
