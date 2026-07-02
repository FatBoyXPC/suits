{ pkgs, ... }:

{
  systemd.user.services.polybar = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polybarFull}/bin/polybar --config=${./polybar-config.ini}";
    };
  };
}
