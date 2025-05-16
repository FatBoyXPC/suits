{
  _module.args.flakeRoot = ../.;

  imports = [
    # Inputs
    ./unfree-packages.nix

    # Outputs
    ./packages.nix
    ./nixos-hosts.nix

    # Development
    ./formatting.nix
    ./dev-shell.nix
  ];
}
