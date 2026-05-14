{ pkgs }:

let
  clipit = pkgs.callPackage ./clipit.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "cgl";

  runtimeInputs = with pkgs; [
    python3
    clipit
  ];

  text = ''
    python3 - "$1" <<'PYTHON' | clipit
    # Git Commit Link
    # That pun on git/get! LOLOL!

    from subprocess import check_output
    import sys

    commit = sys.argv[1]
    remoteOrigin = check_output('git config --get remote.origin.url', shell=True, universal_newlines=True).rstrip()
    url = remoteOrigin.replace(':', '/').replace('git@', 'https://').replace('.git', '/')
    url = url + 'commit/' + commit
    print(url)
    PYTHON
  '';
}
