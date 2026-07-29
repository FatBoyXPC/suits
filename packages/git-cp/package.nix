{
  coreutils,
  git,
  writeShellApplication,
}:

writeShellApplication {
  name = "git-cp";

  runtimeInputs = [
    coreutils
    git
  ];

  text = ''
    cp -r "$1" "$2"
    git add -N "$2"
  '';
}
