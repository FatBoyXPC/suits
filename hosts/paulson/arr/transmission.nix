{ config, ... }:
let
  host = config.vpnNamespaces.wg.namespaceAddress;
  port = config.services.transmission.settings.rpc-port;
  mediaDir = "/mnt/cosmos/media";
in
{
  services = {
    transmission = {
      enable = true;
      group = "media";
      settings = {
        download-dir = "${mediaDir}/torrents";
        incomplete-dir = "${config.services.transmission.settings.download-dir}/incomplete";
        ratio-limit-enabled = true;
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist-enabled = "false";
        rpc-host-whitelist-enabled = "false";
        # Allow group to write to these files (the default is 022).
        umask = 2;
      };
    };

    nginx.virtualHosts."transmission.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://${host}:${toString port}";
      };
    };
  };

  systemd.services.transmission = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
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
