{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.radarr.settings.server.port;
in
{
  services = {
    radarr = {
      enable = true;
      group = "media";
    };

    nginx.virtualHosts."radarr.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://${host}:${toString port}";
      };
    };
  };

  systemd.services.radarr = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
    unitConfig = {
      RequiresMountsFor = "/mnt/cosmos/media";
    };
  };

  vpnNamespaces.wg.portMappings = [
    {
      from = port;
      to = port;
      protocol = "tcp";
    }
  ];
}
