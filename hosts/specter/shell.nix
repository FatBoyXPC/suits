{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
  };
}
