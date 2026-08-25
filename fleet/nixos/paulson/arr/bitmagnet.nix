{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = 3333; # config.services.bitmagnet.settings.http_server.local_address is ":3333" and I don't want to parse it.
in
{
  services.bitmagnet = {
    enable = true;
    group = "media";
  };

  fat.proxy.bitmagnet = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.bitmagnet = {
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
