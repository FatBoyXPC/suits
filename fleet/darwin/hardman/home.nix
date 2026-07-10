{
  imports = [
    ../../../hm-modules/docker.nix
    ../../../hm-modules/shared.nix
  ];

  programs = {
    git.settings = {
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
    };
  };

  home.stateVersion = "26.11";
}
