{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = config.services.bazarr.listenPort;
in
{
  services.bazarr = {
    enable = true;
    group = "media";
  };

  fat.proxy.bazarr = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.bazarr = {
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
