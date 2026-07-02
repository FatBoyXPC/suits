{
  _module.args.flakeRoot = ../.;

  imports = [
    # Inputs
    ./unfree-packages.nix

    # Outputs
    ./packages.nix
    ./fleet.nix

    # Development
    ./formatting.nix
    ./dev-shell.nix
  ];
}
