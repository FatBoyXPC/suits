{
  inputs,
  config,
  ...
}:

{
  imports = [ inputs.vpn-confinement.nixosModules.default ];

  vpnNamespaces.mvd = {
    enable = true;
    wireguardConfigFile = "/etc/secrets/wireguard.conf";
    namespaceAddress = "172.20.0.1";
    namespaceAddressIPv6 = "fda0:f78f:a59e:20::1";
    bridgeAddress = "172.20.0.254";
    bridgeAddressIPv6 = "fda0:f78f:a59e:20::ff";
    accessibleFrom = [
      "192.168.2.0/24"
      #config.snow.subnets.overlay.ipv6 # <<<
    ];
  };

  systemd.services.mvd.serviceConfig = {
    Restart = "on-failure";
    # Don't allow dependent services to see failures, otherwise those services
    # will get stuck due to a dependency failing. This hides that failure.
    # See <https://github.com/systemd/systemd/pull/27584> for details.
    RestartMode = "direct";
    # Ensure that we never give up trying to restart the service (is this
    # really the simplest way to accomplish that?)
    RestartSec = 3;
    StartLimitIntervalSec = 60;
    StartLimitBurst = 20;
  };

  # Allow communication *out* of the network namespace to our `accessibleFrom`
  # subnets. The reverse (traffic going into the namespace) works out of the
  # box because [`VPN-Confinment` sets up a
  # DNAT](https://github.com/Maroka-chan/VPN-Confinement/blob/08cdda8013611e874ac6d3d59d508e56dfee0405/modules/firewall-utils.nix#L16-L25)
  # Perhaps `VPN-Confinement` would be open to a PR adding this?
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    internalInterfaces = [ "mvd-br" ];
  };
}
