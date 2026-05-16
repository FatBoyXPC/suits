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
  diffHighlightAlt = pkgs.symlinkJoin {
    name = "diff-highlight";
    paths = [ pkgs.git ];
    postBuild = ''
      mkdir -p $out/bin
      ln -s ${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight $out/bin/diff-highlight
    '';
  };
  passAlt = (pkgs.pass.override { dmenu = self'.packages.dmenu; });
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
  paths =
    (with pkgs; [
      bc
      calibre
      diff-so-fancy
      fzf
      git
      gnugrep
      imagemagick
      jq
      libreoffice-fresh
      mycli
      networkmanagerapplet
      polybarFull
      ripgrep
      silver-searcher
      tldr
      tmux
      uhk-agent
      unzip
      weechat
      whois
      xcwd
    ])
    ++ (with self'.packages; [
      autoperipherals
      cgl
      clcl
      clipit
      colorscheme
      dmenu
      dsf
      emoji
      middle-paste
      neovim
      screenshot
    ])
    ++ [
      chromiumAlt
      diffHighlightAlt
      passAlt
      slackAlt
      shtuff
      withAlacrittyAlt
    ];
  passthru.wrapped = self'.packages.my-nix.override { wrapsWithNixGl = true; };
}
