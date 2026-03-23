{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.radarr.settings.server.port;
in
{
  services.radarr = {
    enable = true;
    group = "media";

    settings.auth.method = "External";
  };

  fat.proxy.radarr = {
    target = {
      inherit host port;
    };

    protected.lan = false;
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
