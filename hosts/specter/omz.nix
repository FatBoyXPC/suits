{ pkgs, ... }:

{
  home.file.".oh-my-zsh".source =
    let

      omz = pkgs.symlinkJoin {
        name = "oh-my-zsh with plugins";
        paths = [
          pkgs.oh-my-zsh
        ];
        postBuild = ''
          ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/share/oh-my-zsh/custom/themes/powerlevel10k
          ln -s ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting $out/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        '';
      };

    in
    "${omz}/share/oh-my-zsh";
}
