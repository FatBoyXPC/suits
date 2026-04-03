{ config, ... }:
let
  host = config.vpnNamespaces.mvd.namespaceAddress;
  port = config.services.jellyseerr.port;
in
{
  services.jellyseerr.enable = true;

  fat.proxy.seerr = {
    target = {
      inherit host port;
    };

    protected.lan = false;
  };

  systemd.services.jellyseerr = {
    # Set `HOME` as a workaround for <https://github.com/Maroka-chan/VPN-Confinement/issues/36>.
    environment.HOME = config.services.jellyseerr.configDir;
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
