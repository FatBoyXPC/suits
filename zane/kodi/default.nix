{ config, pkgs, ... }:

let
  myKodiPackages = pkgs.callPackage ./packages { };
  myKodi = pkgs.kodi.withPackages (builtin_kodi_packages: [
    myKodiPackages.asgard
  ]);

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
