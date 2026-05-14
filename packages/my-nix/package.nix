{
  symlinkJoin,
  pkgs,
  inputs,
  inputs',
  self',
  wrapsWithNixGl ? false,
}:

let
  shtuff = inputs'.shtuff.packages.default;
  with-alacritty = inputs'.with-alacritty.packages.default;
  autoperipherals = self'.packages.autoperipherals;
  chromiumAlt = symlinkJoin {
    name = "chromium";
    paths = [
      (pkgs.chromium.override {
        commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })
    ];
    buildInputs = [ pkgs.makeWrapper ];
    # Adding these as command line flags doesn't seem to work. Perhaps
    # because we don't have this patch?
    # https://github.com/archlinux/svntogit-packages/blob/2aa76e8dfdd647d1ca0fe1d8780459660407bad2/chromium/trunk/use-oauth2-client-switches-as-default.patch
    postBuild = ''
      wrapProgram $out/bin/chromium \
        --set GOOGLE_DEFAULT_CLIENT_ID 77185425430.apps.googleusercontent.com \
        --set GOOGLE_DEFAULT_CLIENT_SECRET OTJgUOQcT7lO7GsGZq2G4IlT
    '';
  };
  colorschemeAlt = self'.packages.colorscheme;
  diffHighlightAlt = pkgs.symlinkJoin {
    name = "diff-highlight";
    paths = [ pkgs.git ];
    postBuild = ''
      mkdir -p $out/bin
      ln -s ${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight $out/bin/diff-highlight
    '';
  };
  dmenuAlt = self'.packages.dmenu;
  neovimAlt = self'.packages.neovim;
  passAlt = (pkgs.pass.override { dmenu = dmenuAlt; });
  slackAlt = symlinkJoin {
    name = "slack";
    paths = [ pkgs.slack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/slack \
        --set BROWSER chromium
    '';
  };
  maybe-wrap-nixgl =
    if wrapsWithNixGl then pkgs.callPackage ./wrap-nixgl.nix { inherit inputs; } else p: p;
  withAlacrittyAlt = maybe-wrap-nixgl with-alacritty;
in

symlinkJoin {
  name = "my-nix";
  paths = with pkgs; [
    autoperipherals
    bc
    calibre
    chromiumAlt
    colorschemeAlt
    diff-so-fancy
    diffHighlightAlt
    dmenuAlt
    fzf
    git
    gnugrep
    imagemagick
    jq
    kitty # only because alacritty was slow <<<
    libreoffice-fresh
    mycli
    neovimAlt
    networkmanagerapplet
    passAlt
    polybarFull
    ripgrep
    shtuff
    silver-searcher
    slackAlt
    tldr
    tmux
    uhk-agent
    unzip
    weechat
    whois
    withAlacrittyAlt
    xcwd
    (callPackage ./bin/cgl.nix { inherit pkgs; })
    (callPackage ./bin/clcl.nix { inherit pkgs; })
    (callPackage ./bin/clipit.nix { inherit pkgs; })
    (callPackage ./bin/middle-paste.nix { inherit pkgs; })
    (callPackage ./bin/screenshot.nix { inherit pkgs; })
  ];
  passthru.wrapped = self'.packages.my-nix.override { wrapsWithNixGl = true; };
}
