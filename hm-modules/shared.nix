{
  imports = [
    ./git.nix
  ];

  programs = {
    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
