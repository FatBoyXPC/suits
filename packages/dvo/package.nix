{
  self',
  writeShellApplication,
}:

writeShellApplication {
  name = "dvo";

  runtimeInputs = [
    self'.packages.neovim
  ];

  text = ''
    # dev vim open
    nvim --server "$PWD/nvim.pipe" --remote "$@"
  '';
}
