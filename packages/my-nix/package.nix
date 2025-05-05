{
  symlinkJoin,
  pkgs,
  inputs,
  self',
  wrapsWithNixGl ? false,
}:

let
  shtuff = inputs.shtuff.packages.x86_64-linux.default; # <<< TODO: Change to inputs'
  with-alacritty = inputs.with-alacritty.packages.x86_64-linux.default; # <<< TODO: Change to inputs'
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
  flameshotAlt = self'.packages.flameshot;
  mycliAlt = pkgs.mycli.overridePythonAttrs {
    patches = [
      (pkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/dbcli/mycli/pull/1198.patch";
        hash = "sha256-NntPUeNgKjRCHXhBfYqyXhFSysk317a/pdDwvUyFx44=";
      })
    ];
  };
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
    self'.packages.colorscheme
    darktable
    diff-so-fancy
    direnv
    dmenu
    docker
    docker-compose
    flameshotAlt
    fzf
    git
    gnugrep
    imagemagick
    jq
    kitty # only because alacritty was slow <<<
    libreoffice-fresh
    mycliAlt
    neovim
    networkmanagerapplet
    (pass.override { dmenu = self'.packages.dmenu; })
    polybarFull
    shtuff
    silver-searcher
    slackAlt
    steam
    tldr
    tmux
    uhk-agent
    unzip
    weechat
    whois
    withAlacrittyAlt
    xcwd
  ];
  passthru.wrapped = self'.packages.my-nix.override { wrapsWithNixGl = true; };
}
