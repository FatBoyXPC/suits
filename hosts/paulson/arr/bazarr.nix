{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.bazarr.listenPort;
in
{
  services = {
    bazarr = {
      enable = true;
      group = "media";
    };
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
