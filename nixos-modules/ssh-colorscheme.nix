{
  lib,
  pkgs,
  self',
  ...
}:

let
  inherit (pkgs) openssh writeShellApplication;

  light-dark-ssh = writeShellApplication {
    name = "light-dark-ssh";

    runtimeInputs = [
      self'.packages.colorscheme
    ];

    text = ''
      # If there's no DISPLAY (perhaps we're in a TTY or are sshed to this machine),
      # just ssh, don't bother with colorschemes.
      if [ -z "''${DISPLAY+x}" ]; then
        exec ${lib.getExe openssh} "$@"
      fi

      colorscheme set current light
      function finish {
          colorscheme clear current
      }
      trap finish EXIT

      ${lib.getExe openssh} "$@"
    '';
  };
in
{
  # Note: we intentionally expose `light-dark-ssh` as a shell alias rather than
  # a `ssh` binary in the path.
  # This is nice, as it captures human triggered ssh incantations, but not
  # stuff like a `git fetch` (which invokes ssh under the hood, and would
  # result in distracting flickering).
  programs.zsh.interactiveShellInit =
    # bash
    ''
      alias ssh=${lib.getExe light-dark-ssh}
    '';
}
