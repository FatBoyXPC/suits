{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = config.services.sonarr.settings.server.port;
in
{
  services.sonarr = {
    enable = true;
    group = "media";

    settings.auth.method = "External";
  };

  fat.proxy.sonarr = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.sonarr = {
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
