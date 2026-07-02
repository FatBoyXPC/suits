{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = config.services.seerr.port;
in
{
  services.seerr.enable = true;

  fat.proxy.seerr = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.seerr = {
    # Set `HOME` as a workaround for <https://github.com/Maroka-chan/VPN-Confinement/issues/36>.
    environment.HOME = config.services.seerr.configDir;
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
