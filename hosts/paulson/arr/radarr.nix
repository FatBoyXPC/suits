{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
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
      vpnNamespace = "mvd";
    };
    unitConfig = {
      RequiresMountsFor = "/mnt/cosmos/media";
    };
  };

  vpnNamespaces.mvd.portMappings = [
    {
      from = port;
      to = port;
      protocol = "tcp";
    }
  ];
}
