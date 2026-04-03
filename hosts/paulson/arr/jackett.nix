{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = config.services.jackett.port;
in
{
  services.jackett = {
    enable = true;
    group = "media";
  };

  fat.proxy.jackett = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.jackett = {
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
