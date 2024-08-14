{ config, pkgs, ... }:

let
  myKodi = pkgs.kodi;

in
{
  systemd.user.services = {
    "kodi" = {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${myKodi}/bin/kodi";
      };
    };
  };
}
