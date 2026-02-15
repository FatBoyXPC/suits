{ pkgs }:

pkgs.flameshot.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    ./0000-issue-1072-workaround.diff
  ];
})
