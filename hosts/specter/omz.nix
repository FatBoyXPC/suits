{ pkgs, ... }:

{
  home.file.".oh-my-zsh".source = let

    omz = pkgs.symlinkJoin {
      name = "oh-my-zsh with plugins";
      paths = [
        pkgs.oh-my-zsh
      ];
      postBuild = ''
        ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/share/oh-my-zsh/custom/themes/powerlevel10k
      '';
    };

    in
      "${omz}/share/oh-my-zsh";
}
