{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.jackett.port;
in
{
  services = {
    jackett = {
      enable = true;
      group = "media";
    };

    nginx.virtualHosts."jackett.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://${host}:${toString port}";
      };
    };
  };

  systemd.services.jackett = {
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
