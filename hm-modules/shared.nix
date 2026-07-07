{
  imports = [
    ./git.nix
    ./omz.nix
  ];

  programs = {
    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
