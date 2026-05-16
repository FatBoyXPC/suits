{
  diffutils,
  diff-so-fancy,
  less,
  writeShellApplication,
}:

writeShellApplication {
  name = "dsf";

  runtimeInputs = [
    diffutils
    diff-so-fancy
    less
  ];

  text = ''
    diff -u --color=always "$@" | diff-so-fancy | less "$LESS"
  '';
}
