{ lib, pkgs, ... }:

{
  programs.zsh.loginShellInit = ''
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && SHLVL=0 exec startx
  '';

  programs.nm-applet.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;
    displayManager.startx = {
      enable = true;
      generateScript = true;
      #execOnLogin = true;
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      enableConfiguredRecompile = true;
      #config = builtins.readFile ../../packages/xmonad/xmonad.hs;
    };
    autoRepeatDelay = 300;
    autoRepeatInterval = 30;
  };

  systemd.user.services = {
    "xsettingsd" = {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
      };
    };
    "pasystray" = {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = [ pkgs.pavucontrol ];
      serviceConfig = {
        ExecStart = "${pkgs.pasystray}/bin/pasystray";
      };
    };
    #"dunst" = {
    #enable = true;
    #wantedBy = [ "graphical-session.target" ];
    #partOf = [ "graphical-session.target" ];
    ## `stage2ServiceConfig` in `nixos/lib/systemd-lib.nix` really wants to give
    ## us a default `PATH`. However, dunst currently uses `xdg-open` to fire up a
    ## browser, and *that* needs a PATH with whatever default browser we've
    ## got set up. So, it's better to use systemctl's "user environment block"
    ## (populated by xsessionWrapper when it calls `systemctl
    ## import-environment`), because that'll have the right PATH and BROWSER,
    ## but to inherit that PATH, we have to make sure we don't specify a PATH
    ## whatsoever.
    #path = lib.mkForce [ ];
    #serviceConfig = {
    #ExecStart = "${flake'.packages.dunst}/bin/dunst";
    #};
    #};
    "numlock-on" = {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.numlockx}/bin/numlockx on";
      };
    };
    #polybar = {
    #enable = true;
    #wantedBy = [ "graphical-session.target" ];
    #partOf = [ "graphical-session.target" ];
    #serviceConfig = {
    #ExecStart = "${pkgs.polybarFull}/bin/polybar --config=${polybarConfig}";
    #};
    #};
  };
}
