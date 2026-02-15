{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.sonarr.settings.server.port;
in
{
  services = {
    sonarr = {
      enable = true;
      group = "media";
    };

    nginx.virtualHosts."sonarr.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://${host}:${toString port}";
      };
    };
  };

  systemd.services.sonarr = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
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
