{ lib, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      color = {
        diff = {
          commit = "172 bold";
          frag = "33 bold";
          meta = "130";
          new = "34 bold";
          old = "196 bold";
          whitespace = "red reverse";
        };

        diff-highlight = {
          newHighlight = "34 bold 22";
          newNormal = "34 bold";
          oldHighlight = "196 bold 52";
          oldNormal = "196 bold";
        };

        ui = true;
      };

      commit = {
        gpgSign = true;
      };

      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less $LESS";
        excludesFile = "~/.gitignore_global";
      };

      github.user = "FatBoyXPC";

      gpg.ssh.allowedSignersFile = "${pkgs.writeText "allowed-signers" ''
        james.lachance@allyms.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDzzdv7APurZsrONkhWmL64MWC9tOx3aY2GrmG0PLsUt
      ''}";

      log.follow = true;
      pull.rebase = false;
      rerere.enabled = true;

      user = {
        name = "James LaChance";
        email = "fatboyxpc@gmail.com";
        signingKey = lib.mkDefault "C4ED3CA232118969";
      };
    };
  };
}
