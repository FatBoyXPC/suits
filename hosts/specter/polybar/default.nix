{ pkgs, ... }:

let
  polybarConfig = pkgs.substituteAll {
    src = ./polybar-config.ini;
  };
in
{
  systemd.user.services.polybar = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polybarFull}/bin/polybar --config=${polybarConfig}";
    };
  };
}
